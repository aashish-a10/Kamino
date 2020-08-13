//
//  ResidentDetailViewController.swift
//

import Foundation
import UIKit
import RxSwift
import CommonKit
import ServiceKit

public protocol ResidentDetailsViewModelFactory {
    func makeResidentDetailsViewModel() -> ResidentDetailViewModel
}

public final class ResidentDetailViewController: NiblessViewController {
    
    // MARK: Private Properties
    private let viewModel: ResidentDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    public init(viewModelFactory: ResidentDetailsViewModelFactory) {
        self.viewModel = viewModelFactory.makeResidentDetailsViewModel()
        super.init()
    }
    
    // MARK: Lifecycle
    public override func loadView() {
        self.view = ResidentDetailView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
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
