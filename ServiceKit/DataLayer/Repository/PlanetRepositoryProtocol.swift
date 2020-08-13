//
//  PlanetRepositoryProtocol.swift
//

import Foundation

public protocol PlanetRepositoryProtocol {
    func fetchPlanetDetails(forId: Int, completion: @escaping (Result<Planet, Error>) -> Void)
    func fetchResidentDetail(forId: Int, completion: @escaping (Result<Resident, Error>) -> Void)
    func likePlanet(forId: Int, completion: @escaping (Result<Like, Error>) -> Void)
    func downloadImage(urlString url: String, completion: @escaping (Result<Data, Error>) -> Void)
}
