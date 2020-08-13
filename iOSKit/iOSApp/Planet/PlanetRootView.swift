//
//  PlanetRootView.swift
//

import UIKit
import RxSwift
import RxCocoa
import CommonKit
import ServiceKit

enum CellIdentifier: String {
    case cell
    case resident
}

class PlanetRootView: NiblessView {
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private let viewModel: PlanetViewModel
    private var hierarchyNotReady = true
    
    private let planetImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(Constants.Action.like, for: .normal)
        button.setTitle(Constants.Action.liked, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let residentsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(Constants.Action.resident, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loadingView: LoadingView = {
        let v = LoadingView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: Initializer
    init(frame: CGRect = .zero,
         viewModel: PlanetViewModel) {
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
        wireController()
        bindViewModelToViews()
        hierarchyNotReady = false
    }
    
    // MARK: Private Methods
    private func constructHierarchy() {
        addSubview(tableView)
        addSubview(likeButton)
        addSubview(residentsButton)
        
        addSubview(planetImageView)
        addSubview(loadingView)
        setupGestureRecognizer()
    }
    
    @objc
    private func onImageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        AnimatorFactory.scaleUp(view: planetImageView).startAnimation()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(onImageTap(tapGestureRecognizer:))
        )
        planetImageView.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        planetImageView.addGestureRecognizer(tapGesture)
    }
    
    private func activateConstraints() {
        activateConstraintsImageView()
        activateConstraintsLikeButton()
        activateConstraintsResidentsButton()
        activateConstraintsTableView()
        activateConstraintsActivityIndicator()
    }
    
    private func wireController() {
        likeButton.addTarget(self, action: #selector(likePlanet), for: .touchUpInside)
        residentsButton.addTarget(self, action: #selector(showResidents), for: .touchUpInside)
    }
    
    @objc
    private func likePlanet() {
        viewModel.likePlanet(forId: viewModel.id)
    }
    
    @objc
    private func showResidents() {
        viewModel.showResident()
    }
}

// MARK: Layout
private extension PlanetRootView {
    func activateConstraintsImageView() {
        planetImageView.translatesAutoresizingMaskIntoConstraints = false
        let top = planetImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let leading = planetImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = planetImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let height = planetImageView.heightAnchor.constraint(equalToConstant: 250.0)
        NSLayoutConstraint.activate(
            [top, leading, trailing, height])
    }
    
    func activateConstraintsLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = likeButton.leadingAnchor
            .constraint(equalTo: planetImageView.leadingAnchor, constant: 20)
        let top = likeButton.topAnchor
            .constraint(equalTo: planetImageView.bottomAnchor, constant: 20)
        let height = likeButton.heightAnchor
            .constraint(equalToConstant: 44)
        let width = likeButton.widthAnchor
            .constraint(equalToConstant: 120.0)
        NSLayoutConstraint.activate(
            [leading, width, top, height])
    }
    
    func activateConstraintsResidentsButton() {
        residentsButton.translatesAutoresizingMaskIntoConstraints = false
        let trailing = residentsButton.trailingAnchor
            .constraint(equalTo: planetImageView.trailingAnchor, constant: -20)
        let top = residentsButton.topAnchor
            .constraint(equalTo: planetImageView.bottomAnchor, constant: 20)
        let height = residentsButton.heightAnchor
            .constraint(equalToConstant: 44)
        let width = residentsButton.widthAnchor
            .constraint(equalToConstant: 120.0)
        NSLayoutConstraint.activate(
            [trailing, top, height, width])
    }
    
    func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10.0)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate(
            [top, leading, trailing, bottom])
    }
    
    func activateConstraintsActivityIndicator() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = loadingView.centerXAnchor
            .constraint(equalTo: planetImageView.centerXAnchor)
        let centerY = loadingView.centerYAnchor
            .constraint(equalTo: planetImageView.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
}

// MARK: - Dynamic behaviors
private extension PlanetRootView {
    
    func bindViewModelToViews() {
        bindViewModelToImageView()
        bindViewModelToActivityIndicator()
        bindViewModelToLikeButton()
        bindViewModelToTableView()
    }
    
    func bindViewModelToImageView() {
        viewModel
            .imageDataInput
            .subscribe(onNext: { [weak self] imageData in
                guard self == self, let data = imageData, let image = UIImage(data: data) else { return }
                self?.planetImageView.image = image
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
    
    func bindViewModelToLikeButton() {
        viewModel
            .likeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.likeButton.isEnabled = isEnabled
                self.likeButton.backgroundColor = self.likeButton.backgroundColor?.withAlphaComponent(isEnabled ? 1.0 : 0.7)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToTableView() {
        viewModel.planetDetails.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, element: (String, String)) in
            let indexPath = IndexPath(item: index, section: 0)
            var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue, for: indexPath)
            cell = UITableViewCell(style: .value1,
                                   reuseIdentifier: CellIdentifier.cell.rawValue)
            let (title, detail) = element
            cell.textLabel?.text = title.capitalized
            cell.detailTextLabel?.text = detail.capitalized
            return cell
        }.disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel
            .likeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.likeButton.isEnabled = isEnabled
                self.likeButton.backgroundColor = self.likeButton.backgroundColor?.withAlphaComponent(isEnabled ? 1.0 : 0.7)
            })
            .disposed(by: disposeBag)
    }
}
