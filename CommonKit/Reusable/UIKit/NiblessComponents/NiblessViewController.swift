//
//  NiblessViewController.swift
//

import UIKit

open class NiblessViewController: UIViewController {
    
    // MARK: Public Methods
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
