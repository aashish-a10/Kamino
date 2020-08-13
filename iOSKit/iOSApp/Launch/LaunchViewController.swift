//
//  LaunchViewController.swift
//

import UIKit
import RxSwift
import RxCocoa
import CommonKit
import ServiceKit

public protocol LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel
}

public final class LaunchViewController: NiblessViewController {
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var viewModel: LaunchViewModel
    
    
    // MARK: Initializer
    public init(viewModelFactory: LaunchViewModelFactory) {
        viewModel = viewModelFactory.makeLaunchViewModel()
        super.init()
    }
    
    // MARK: Lifecycle
    public override func loadView() {
        self.view = LaunchView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        viewModel.fetchPlanet(forId: 10)
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
