//
//  PlanetRepository.swift
//

import Foundation

public class PlanetRepository: PlanetRepositoryProtocol {
    
    // MARK: Private Properties
    private let client: APIClient
    
    // MARK: Initializer
    public init(client: APIClient) {
        self.client = client
    }
    
    // MARK: Public Methods
    public func fetchPlanetDetails(forId: Int, completion: @escaping (Result<Planet, Error>) -> Void) {
        client.perform(Planet.self, endpoint: String(forId), completion: completion)
    }
    
    public func fetchResidentDetail(forId: Int, completion: @escaping (Result<Resident, Error>) -> Void) {
        client.perform(Resident.self, endpoint: String(forId), completion: completion)
    }
    
    public func likePlanet(forId: Int, completion: @escaping (Result<Like, Error>) -> Void) {
        client.perform(Like.self, endpoint: String(""), method: .post, bodyParamaters: ["planet_id" : forId], completion: completion)
    }
    
    public func downloadImage(urlString url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        client.downloadImage(urlString: url, completion: completion)
    }
}
