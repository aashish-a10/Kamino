//
//  ResidentDetailView.swift
//

import UIKit
import RxSwift
import RxCocoa
import CommonKit
import ServiceKit

final class ResidentDetailView: NiblessView {
    
    // MARK: Private Properties
    private let viewModel: ResidentDetailViewModel
    private var hierarchyNotReady = true
    private let disposeBag = DisposeBag()
    
    private let residentImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "placeholder")
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    // MARK: Initializer
    init(frame: CGRect = .zero,
         viewModel: ResidentDetailViewModel) {
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
        setupConstraints()
        bindViewModelToViews()
        
        hierarchyNotReady = false
    }
    
    // MARK: Private Methods
    private func constructHierarchy() {
        addSubview(residentImage)
        addSubview(tableView)
        addSubview(loadingView)
    }
}

// MARK: Layout
private extension ResidentDetailView {
    private func setupConstraints() {
        activateConstraintsResidentImage()
        activateConstraintsTableView()
        activateConstraintsActivityIndicator()
    }
    
    private func activateConstraintsResidentImage() {
        residentImage.translatesAutoresizingMaskIntoConstraints = false
        
        let top = residentImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading  = residentImage.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = residentImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height   = residentImage.heightAnchor.constraint(equalToConstant: 250.0)
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = tableView.topAnchor.constraint(equalTo: residentImage.bottomAnchor, constant: 10.0)
        let leading  = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    private func activateConstraintsActivityIndicator() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = loadingView.centerXAnchor
            .constraint(equalTo: residentImage.centerXAnchor)
        let centerY = loadingView.centerYAnchor
            .constraint(equalTo: residentImage.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
}

// MARK: - Dynamic behaviors
private extension ResidentDetailView {
    func bindViewModelToViews() {
        bindViewModelToImageView()
        bindViewModelToActivityIndicator()
        bindViewModelToTableView()
    }
    
    func bindViewModelToImageView() {
        viewModel
            .imageDataInput
            .subscribe(onNext: { [weak self] imageData in
                guard self == self, let data = imageData, let image = UIImage(data: data) else { return }
                self?.residentImage.image = image
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToActivityIndicator() {
        viewModel
            .isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToTableView() {
        viewModel.residentDetails.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, element: (String, String)) in
            let indexPath = IndexPath(item: index, section: 0)
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue, for: indexPath)
            cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.cell.rawValue)
            let (title, detail) = element
            cell.textLabel?.text = title.capitalized
            cell.detailTextLabel?.text = detail.capitalized
            return cell
        }.disposed(by: disposeBag)
    }
}
