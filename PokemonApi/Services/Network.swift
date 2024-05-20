//
//  Network.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation


import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL { get }
}

extension APIResource {
//    var url: URL {
//       
//        //TODO: Initialize the base url diffrently
//        let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
//        
//        // Prepend / if it does not exist in path, otherwise the url components creation will fail
//        let path = self.methodPath
//        if !path.starts(with: "/") {
//            components.path = components.path.appending("/")
//        }
//        components.path = components.path.appending(path)
//        
//        components.queryItems = self.queryItems
//        return components.url!
//    }
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) throws -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?, Error?) -> Void)
}

enum NetworkRequestError: Error, LocalizedError {
    case emptyPayload
    
    var errorDescription: String? {
        switch self {
        case .emptyPayload:
            return "No payload received"
        }
    }
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        
        if let token = SymbleSDKSettings.apiKey {
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        let task = SymbleSDKSettings.session.dataTask(with: request) { [weak self] (data, _ , error) -> Void in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkRequestError.emptyPayload)
                return
            }
            
            if let string = String(data: data, encoding: .utf8) {
                print("kurac \(string)")
            }
            
            do {
                let value = try self?.decode(data)
                DispatchQueue.main.async { completion(value, nil) }
            }
            
            catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
}

class APIRequest<Resource: APIResource> {
    
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
        
    typealias ModelType = Resource.ModelType
    
    func decode(_ data: Data) throws -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(Resource.ModelType.self, from: data)
    }
    
    func execute(withCompletion completion: @escaping (Resource.ModelType?, Error?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

public final class SymbleSDKSettings {
    
    fileprivate static let session: URLSession = {
        // Here you can adjust the session configuration by your likings
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    public static var apiKey: String?
}
