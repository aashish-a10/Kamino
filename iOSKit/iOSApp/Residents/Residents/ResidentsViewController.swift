//
//  ResidentsViewController.swift
//

import Foundation
import UIKit
import RxSwift
import CommonKit
import ServiceKit

public protocol ResidentsViewModelFactory {
    func makeResidentsViewModel() -> ResidentsViewModel
}

public final class ResidentsViewController: NiblessViewController {
    
    // MARK: Private Properties
    private let viewModel: ResidentsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    public init(viewModelFactory: ResidentsViewModelFactory) {
        self.viewModel = viewModelFactory.makeResidentsViewModel()
        super.init()
    }
    
    // MARK: Lifecycle
    public override func loadView() {
        self.view = ResidentsView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        
        viewModel.showResidents()
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

