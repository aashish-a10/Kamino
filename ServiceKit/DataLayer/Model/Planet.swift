//
//  Planet.swift
//

import Foundation

public struct Planet: Codable {
    public let name: String
    public let rotationPeriod: String
    public let residents: [String]
    public let orbitalPeriod: String
    public let diameter: String
    public let climate: String
    public let gravity: String
    public let terrain: String
    public let surfaceWater: String
    public let population: String
    public let imageUrl: String
    private let likes: Int
    
    public lazy var like: Like = {
        Like(likes: likes, planetId: Planet.id)
    }()
    
    public lazy var residentsCount: String = {
        String(residents.count)
    }()
}

extension Planet: Equatable {
    public static func == (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.name == rhs.name &&
            lhs.population == rhs.population &&
            lhs.residents.count == rhs.residents.count
    }
}

extension Planet: Fetchable {
    static var apiBase: String { return "planets"}
    static var id: Int = 10
}

public struct Like: Codable {
    let likes: Int
    let planetId: Int
    
    lazy var count: String = {
        String(likes)
    }()
    
    enum CodingKeys: String, CodingKey {
        case likes = "likes "  // There is an extra space in likes
        case planetId
    }
}

extension Like: Fetchable {
    static var apiBase: String { return Planet.apiBase + "/\(Planet.id)" + "/like"}
    static var id: Int? = nil
}
