//
//  Resident.swift
//

import Foundation

public struct Resident: Codable {
    public let name: String
    public let height: String
    public let mass: String
    public let hairColor: String
    public let skinColor: String
    public let eyeColor: String
    public let birthYear: String
    public let gender: String
    public let homeworld: String
    public let imageUrl: String
}


extension Resident: Equatable {
    public static func == (lhs: Resident, rhs: Resident) -> Bool {
        return lhs.name == rhs.name &&
            lhs.height == rhs.height &&
            lhs.mass   == rhs.mass
    }
}

extension Resident: Fetchable {
    static var apiBase: String { return "residents" }
}
