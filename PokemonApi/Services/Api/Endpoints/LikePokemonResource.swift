//
//  CreateFavoriteResource.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import Foundation

struct LikePokemonResource: APIResource {
    typealias ModelType = NoPayload
    typealias Payload = LikePokemonPayload
        
    var methodPath: String = "pokemon"
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: String {
        return "POST"
    }
    
    var url: URL {
        return URL(string: "https://webhook.site/1e12550f-63bf-4017-b3bd-c086f9baee2e")!
    }
}

struct LikePokemonPayload: Codable {
    var id: Int
    var name: String
}
