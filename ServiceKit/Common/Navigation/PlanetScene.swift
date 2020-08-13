//
//  PlanetScene.swift
//

import Foundation

public enum PlanetScene {
    case planet
    case residents
    case residentDetail(resident: Resident)
}

extension PlanetScene: Equatable {
    public static func == (lhs: PlanetScene, rhs: PlanetScene) -> Bool {
        switch (lhs, rhs) {
        case (.planet, .planet):
            return true
        case (.residents, .residents):
            return true
        case let (.residentDetail(l), .residentDetail(r)):
            return l == r
        default:
            return false
        }
    }
}
