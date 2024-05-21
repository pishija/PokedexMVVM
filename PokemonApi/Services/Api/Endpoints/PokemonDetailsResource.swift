//
//  PokemonDetailsResource.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation

struct PokemonDetailsResource: APIResource {
    typealias ModelType = PokemonDetails
    typealias Payload = NoPayload
    
    let pokemon: Pokemon
    
    var url: URL {
        return pokemon.url
    }
    
    var method: String {
        return "GET"
    }
    
    var methodPath: String {
        return ""
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

//MARK: Models

struct PokemonDetails: Codable {
    var height: Float
    var weight: Float
    var id: Int
    var is_default: Bool
    var name: String
    let sprites: Sprites
    let types: [PokemonTypeSlot]
    let base_experience: Float
    let order: Int
}

struct Sprites: Codable {
    let front_default: URL?
}

struct PokemonType: Codable {
    let name: String
    let url: URL
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}
