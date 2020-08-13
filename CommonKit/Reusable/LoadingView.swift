//
//  LoadingView.swift
//

import UIKit

public class LoadingView: UIView {
    public let activityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setup() {
        backgroundColor = .white
        addSubview(activityIndicator)
        activateConstraintsActivityIndicator()
    }
    
    func activateConstraintsActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = activityIndicator.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
}
