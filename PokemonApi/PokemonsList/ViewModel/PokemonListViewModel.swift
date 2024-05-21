//
//  PokemonListViewModel.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import Foundation

class PokemonListViewModel: ObservableObject {
    
    @Published var datasource: [PokemonViewModel] = []
    @Published var errorMessage: String?
    @Published var showLoading: Bool = false
    @Published var showBottomLoading: Bool = false
    
    private var request: APIRequest<PokemonsResource>?
    private var response: PokemonResponse<[Pokemon]>?
    
    //MARK: Initialization
    
    init() {
        
        let resource = PokemonsResource()
        self.request = APIRequest(resource: resource)
        
        self.showLoading = true
        self.request?.execute { [weak self] response, error in
            self?.showLoading = false
            self?.response = response
            guard error == nil else {
                self?.errorMessage = error?.localizedDescription
                return
            }
            
            guard let pokemons = response?.results else {
                self?.errorMessage = "No pokemons/No results received."
                return
            }
            
            self?.datasource = pokemons.map({ PokemonViewModel(pokemon: $0) })
        }
    }
    
    //MARK: Interface
    
    func loadNextPage() {
        
        if let next = self.response?.next, !self.showBottomLoading {
            var resource = PokemonsResource()
            resource.externalURL = next
            self.request = APIRequest(resource: resource)
            
            self.showBottomLoading = true
            self.request?.execute { [weak self] response, error in
                self?.showBottomLoading = false
                self?.response = response
                guard error == nil else {
                    self?.errorMessage = error?.localizedDescription
                    return
                }
                
                guard let pokemons = response?.results else {
                    self?.errorMessage = "No pokemons/No results received."
                    return
                }
                
                self?.datasource.append(contentsOf: pokemons.map({ PokemonViewModel(pokemon: $0) }))
            }
        }
        
    }
}
