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
    associatedtype Payload: Encodable
    
    var methodPath: String { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL { get }
    var method: String { get }
    
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    associatedtype Payload
    func decode(_ data: Data) throws -> ModelType?
    func encode(_ payload: Payload) throws -> Data?
    func execute(body: Payload?, withCompletion completion: @escaping (ModelType?, Error?) -> Void)
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
    fileprivate func load(request: URLRequest,  withCompletion completion: @escaping (ModelType?, Error?) -> Void) {
        
        var request = request
        
        if let token = ApiSettings.apiKey {
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        let task = ApiSettings.session.dataTask(with: request) { [weak self] (data, _ , error) -> Void in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkRequestError.emptyPayload)
                return
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
    let request: URLRequest
    
    init(resource: Resource) {
        self.resource = resource
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        self.request = request
    }
}

extension APIRequest: NetworkRequest {

    typealias ModelType = Resource.ModelType
    
    func decode(_ data: Data) throws -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(Resource.ModelType.self, from: data)
    }
    
    func encode(_ payload: Resource.Payload) throws -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return try encoder.encode(payload)
    }
    
    func execute(body: Resource.Payload? = nil, withCompletion completion: @escaping (Resource.ModelType?, Error?) -> Void) {
        var data: Data? = nil
        var request = self.request

    
        if let aBody = body {
            data = try? self.encode(aBody)
            request.httpBody = data
        }
     
        load(request: request, withCompletion: completion)
    }
}

public final class ApiSettings {
    
    fileprivate static let session: URLSession = {
        // Here you can adjust the session configuration by your likings
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    public static var apiKey: String?
}

struct NoPayload: Codable {
    
}
