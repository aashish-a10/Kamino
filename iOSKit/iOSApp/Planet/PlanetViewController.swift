//
//  PlanetViewController.swift
//

import Foundation
import UIKit
import RxSwift
import CommonKit
import ServiceKit

public protocol PlanetViewModelFactory {
    func makePlanetViewModel() -> PlanetViewModel
}

public final class PlanetViewController: NiblessViewController {
    
    // MARK: Private Properties
    private let viewModel: PlanetViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    public init(viewModelFactory: PlanetViewModelFactory) {
        self.viewModel = viewModelFactory.makePlanetViewModel()
        super.init()
        
        self.title = viewModel.title
    }
    
    // MARK: Lifecycle
    public override func loadView() {
        self.view = PlanetRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.downloadImage()
        handleErrorMessages()
    }
    
    // MARK: Private Methods
    private func handleErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else {
                    return
                }
                self.present(errorMessage: errorMessage,
                             withPresentationState: self.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }
}
