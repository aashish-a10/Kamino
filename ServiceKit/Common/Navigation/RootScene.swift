//
//  RootScene.swift
//

import Foundation

public enum RootScene {
    case launching
    case show(planet: Planet)
}

extension RootScene: Equatable {
    public static func == (lhs: RootScene, rhs: RootScene) -> Bool {
        switch (lhs, rhs) {
        case (.launching, .launching):
            return true
        case let (.show(l), .show(r)):
            return l == r
        default:
            return false
        }
    }
}
