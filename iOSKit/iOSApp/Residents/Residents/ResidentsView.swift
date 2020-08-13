//
//  ResidentsView.swift
//

import Foundation
import UIKit
import RxSwift
import CommonKit
import ServiceKit

class ResidentsView: NiblessView {
    
    // MARK: Private Properties
    private let viewModel: ResidentsViewModel
    private var hierarchyNotReady = true
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    // MARK: Initializer
    init(frame: CGRect = .zero,
         viewModel: ResidentsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    // MARK: Lifecycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        constructHierarchy()
        setupConstraints()
        bindViewModelToViews()
        hierarchyNotReady = false
    }
    
    // MARK: Private Methods
    private func constructHierarchy() {
        addSubview(tableView)
        addSubview(loadingView)
    }
}

// MARK: Layout
private extension ResidentsView {
    private func setupConstraints() {
        activateConstraintsTableView()
        activateConstraintsActivityIndicator()
    }
    
    private func activateConstraintsTableView() {
        let top = tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading  = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom   = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate(
            [top, leading, trailing, bottom])
    }
    
    private func activateConstraintsActivityIndicator() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let top = loadingView.topAnchor.constraint(equalTo: tableView.topAnchor)
        let leading  = loadingView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor)
        let trailing = loadingView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        let bottom   = loadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        NSLayoutConstraint.activate(
            [top, leading, trailing, bottom])
    }
}

// MARK: - Dynamic behaviors
private extension ResidentsView {
    
    private func bindViewModelToViews() {
        bindViewModelToTableView()
        bindViewModelToActivityIndicator()
        bindViewModelToLoadingView()
    }
    
    private func bindViewModelToTableView() {
        viewModel.residents.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, resident: Resident) in
            let indexPath = IndexPath(item: index, section: 0)
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue, for: indexPath)
            cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.cell.rawValue)
            cell.textLabel?.text = resident.name
            cell.detailTextLabel?.text = resident.gender
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Resident.self)
            .subscribe(onNext: { [weak self] resident in
                guard let self = self else { return }
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                  self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
                self.viewModel.showResidentDetail(for: resident)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToActivityIndicator() {
        viewModel
            .isLoading
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToLoadingView() {
        viewModel
            .isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
