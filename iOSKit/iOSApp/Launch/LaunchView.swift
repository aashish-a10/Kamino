//
//  LaunchView.swift
//

import UIKit
import RxSwift
import RxCocoa
import CommonKit
import ServiceKit

class LaunchView: NiblessView {
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let viewModel: LaunchViewModel
    private var hierarchyNotReady = true
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    // MARK: Initializer
    init(frame: CGRect = .zero,
         viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    // MARK: Lifecycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        bindViewModelToViews()
        hierarchyNotReady = false
    }
    
    // MARK: Private Methods
    private func constructHierarchy() {
        addSubview(loadingView)
    }
    
    private func activateConstraints() {
        activateConstraintsActivityIndicator()
    }
}

// MARK: Layout
private extension LaunchView {
    func activateConstraintsActivityIndicator() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = loadingView.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = loadingView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
}

// MARK: - Dynamic behaviour
private extension LaunchView {
    func bindViewModelToViews() {
        bindViewModelActivityIndicator()
    }
    
    func bindViewModelActivityIndicator() {
        viewModel
            .isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
