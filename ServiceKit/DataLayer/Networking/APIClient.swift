//
//  APIClient.swift
//

import Foundation

enum Constant {
    static let baseURL =  URL(string: "https://private-anon-cf2c70bccf-starwars2.apiary-mock.com/")!
}

public final class APIClient {
    
    // MARK: Private Properties
    private let baseURL: URL!
    private let transport: Transport
    private let responseQueue: DispatchQueue?
    private(set) var urlCache: URLCache? = nil
    
    private let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    public static let shared = APIClient(baseURL: Constant.baseURL,
                                         transport: URLSession.cachedSession,
                                         responseQueue: .main)
    
    // MARK: Initializer
    init(baseURL: URL, transport: Transport, responseQueue: DispatchQueue?) {
        self.baseURL = baseURL
        self.transport = transport
        self.responseQueue = responseQueue
        
        guard let session = transport as? URLSession else { return }
        self.urlCache = session.configuration.urlCache
    }
    
    // MARK: Public Methods
    func perform<Model>(_ model: Model.Type,
                        endpoint: String,
                        method: HTTPMethodType = .get,
                        bodyParamaters: [String: Any]? = nil,
                        completion: @escaping (Result<Model, Error>) -> Void) where Model: Fetchable {
        var url = baseURL
            .appendingPathComponent(Model.apiBase)
        if !endpoint.isEmpty {
            url = url.appendingPathComponent("\(endpoint)")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let bodyParamaters = bodyParamaters {
            urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters, bodyEncoding: .jsonSerializationData)
        }
        
        if let cachedData = urlCache?.cachedResponse(for: urlRequest) {
            let result = Result { try decoder.decode(Model.self, from: cachedData.data) }
            self.dispatchResult(result, with: completion)
            return
        }
        
        // Send it to the transport
        transport.send(request: urlRequest, cache: urlCache) { [weak self] data in
            guard let self = self else { return }
            
            let result = Result { try self.decoder.decode(Model.self, from: data.get()) }
            self.dispatchResult(result, with: completion)
        }
        
    }
    
    func downloadImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        
        if let cachedData = urlCache?.cachedResponse(for: urlRequest) {
            self.dispatchResult(.success(cachedData.data), with: completion)
            return
        }
        
        transport.send(request: urlRequest, cache: urlCache) { [weak self] data in
            self?.dispatchResult(data, with: completion)
        }
    }
    
    // MARK: Private Methods
    private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        }
    }
    
    private func dispatchResult<Model> (_ result: Result<Model, Error>, with completion: @escaping (Result<Model, Error>) -> Void) {
        guard let responseQueue = responseQueue else {
            completion(result)
            return
        }
        responseQueue.async {
            completion(result)
        }
    }
}
