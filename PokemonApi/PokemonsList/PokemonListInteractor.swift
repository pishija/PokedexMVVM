//
//  PokemonListInteractor.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation

//TODO: Check if these should be classes or structs
struct PokemonListInteractor {
    
    func findPokemons() {
        
    }
    
}

struct PokemonListPresenter {
    
}

struct Pokemon: Codable {
    var name: String
    var url: URL
}
