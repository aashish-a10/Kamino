//
//  URLSessionExtension.swift
//

import Foundation

private let allowedDiskSize = 100 * 1024 * 1024

public enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
}

public enum BodyEncoding {
    case jsonSerializationData
}

protocol Transport {
    func send(request: URLRequest, cache: URLCache?, completion: @escaping (Result<Data, Error>) -> Void)
}

extension URLSession: Transport {
    func send(request: URLRequest, cache: URLCache?, completion: @escaping (Result<Data, Error>) -> Void)
    {
        let task = self.dataTask(with: request) { (data, response, error) in
            if let error = error { completion(.failure(error)) }
            else if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                cache?.storeCachedResponse(cachedData, for: request)
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    static var cachedSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .reloadRevalidatingCacheData
        //sessionConfiguration.urlCache = URLCache.default
        return URLSession(configuration: sessionConfiguration)
    }()
}

extension URLCache {
    static var `default`: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "dagobah_cache")
    }()
}

protocol Fetchable: Decodable {
    static var apiBase: String { get }
}
