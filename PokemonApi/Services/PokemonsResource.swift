//
//  PokemonsResource.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation

struct PokemonsResource: APIResource {
    typealias ModelType = PokemonResponse<[Pokemon]>
    
    var methodPath: String = "pokemon"
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var url: URL {
        //TODO: Initialize the base url diffrently
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


struct PokemonDetailsResource: APIResource {
    typealias ModelType = PokemonDetails
    
    let pokemon: Pokemon
    
    var url: URL {
        return pokemon.url
    }
    
    var methodPath: String {
        return ""
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    
}

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


