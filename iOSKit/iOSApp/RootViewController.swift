//
//  RootViewController.swift
//

import Foundation
import UIKit
import RxSwift
import CommonKit
import ServiceKit

public final class RootViewController: NiblessViewController {
    
    // MARK: - Private Properties
    private let viewModel: RootViewModel
    private let disposeBag = DisposeBag()
    
    // Child View Controllers
    private let launchViewController: LaunchViewController
    private var planetNavigationViewController: PlanetNavigationViewController?
    
    // Factories
    private let makePlanetNavigationViewController: (Planet) -> PlanetNavigationViewController
    
    // MARK: Initializer
    public init(viewModel: RootViewModel,
                launchController: LaunchViewController,
                planetNavigationControllerFactory: @escaping (Planet) -> PlanetNavigationViewController) {
        self.viewModel = viewModel
        self.launchViewController = launchController
        self.makePlanetNavigationViewController = planetNavigationControllerFactory
        super.init()
    }
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }
    
    // MARK: Private Methods
    private func observeViewModel() {
        let observable = viewModel.view.distinctUntilChanged()
        subscribe(to: observable)
    }
    
    private func subscribe(to observable: Observable<RootScene>) {
        observable
            .subscribe(onNext: { [weak self] view in
                guard let strongSelf = self else { return }
                strongSelf.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    private func present(_ view: RootScene) {
        switch view {
        case .launching:
            presentLaunching()
        case .show(let planet):
            presentPlanetNavigationController(planet)
        }
    }
    
    private func presentLaunching() {
        addFullScreen(childViewController: launchViewController)
    }
    
    private func presentPlanetNavigationController(_ planet: Planet) {
        let planetNavigationViewController = makePlanetNavigationViewController(planet)
        planetNavigationViewController.modalPresentationStyle = .fullScreen
        present(planetNavigationViewController, animated: false) { [weak self] in
            guard let self = self else { return }
            self.remove(childViewController: self.launchViewController)
        }
        self.planetNavigationViewController = planetNavigationViewController
    }
}
