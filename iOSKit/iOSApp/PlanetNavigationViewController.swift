//
//  PlanetNavigationViewController.swift
//

import Foundation
import RxSwift
import CommonKit
import ServiceKit

public final class PlanetNavigationViewController: NiblessNavigationController {
    
    // MARK: - Private Properties
    private let viewModel: PlanetNavigationViewModel
    private let planetViewController: PlanetViewController
    private let residentsViewController: ResidentsViewController
    private var residentDetailViewController: ResidentDetailViewController?
    
    private let disposeBag = DisposeBag()
    
    // Factories
    private let makeResidentDetailViewController: (Resident) -> ResidentDetailViewController
    
    // MARK: Initializer
    public init(viewModel: PlanetNavigationViewModel,
                planetViewController: PlanetViewController,
                residentsViewController: ResidentsViewController,
                residentDetailControllerFactory: @escaping (Resident) -> ResidentDetailViewController) {
        self.viewModel = viewModel
        self.planetViewController = planetViewController
        self.residentsViewController = residentsViewController
        self.makeResidentDetailViewController = residentDetailControllerFactory
        super.init()
    }
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        subscribe(to: viewModel.navigationAction)
    }
    
    // MARK: Private Methods
    private func subscribe(to observable: Observable<PlanetNavigationAction>) {
        observable
            .subscribe(onNext: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.respond(to: action)
            }).disposed(by: disposeBag)
    }
    
    private func respond(to navigationAction: PlanetNavigationAction) {
        switch navigationAction {
        case .present(let view):
            present(view: view)
        }
    }
    
    private func present(view: PlanetScene) {
        switch view {
        case .planet:
            presentPlanet()
        case .residents:
            presentResidents()
        case .residentDetail(let resident):
            presentResidentDetail(resident: resident)
        }
    }
    
    private func presentPlanet() {
        pushViewController(planetViewController, animated: false)
    }
    
    private func presentResidents() {
        pushViewController(residentsViewController, animated: true)
    }
    
    private func presentResidentDetail(resident: Resident) {
        let residentDetailViewController = makeResidentDetailViewController(resident)
        pushViewController(residentDetailViewController, animated: true)
    }
}
