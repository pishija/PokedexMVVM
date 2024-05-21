//
//  PokemonsResource.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation

struct PokemonsResource: APIResource {
    typealias ModelType = PokemonResponse<[Pokemon]>
    typealias Payload = NoPayload
    
    var methodPath: String = "pokemon"
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: String {
        return "GET"
    }
    
    var url: URL {
        
        if let url = self.externalURL {
            return url
        } else {
            let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            
            // Prepend / if it does not exist in path, otherwise the url components creation will fail
            let path = self.methodPath
            if !path.starts(with: "/") {
                components.path = components.path.appending("/")
            }
            components.path = components.path.appending(path)
            
            components.queryItems = self.queryItems
            return components.url!
        }
    }
    
    var externalURL: URL?
}

//MARK: Models

struct PokemonResponse<Data: Codable>: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: Data?
}

struct Pokemon: Codable {
    let name: String
    let url: URL
}
