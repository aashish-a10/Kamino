//
//  NavigationAction.swift
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
    case present(view: ViewModelType)
}
