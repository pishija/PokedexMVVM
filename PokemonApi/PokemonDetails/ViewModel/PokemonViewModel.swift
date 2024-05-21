//
//  PokemonViewModel.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import UIKit

class PokemonViewModel: ObservableObject {
    
    let pokemon: Pokemon
    
    @Published var name: String = ""
    @Published var id: String = ""
    @Published var types: [String] = []
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var order: String = ""
    @Published var experience: String = ""
    @Published var image: UIImage?
    @Published var errorMessage: String?
    @Published var isLiked: Bool?

    private (set) var pokemonDetails: PokemonDetails?

    
    private (set) var request: APIRequest<PokemonDetailsResource>?
    private var isLikedRequest: APIRequest<LikeStatusResource>?
    
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        self.request = APIRequest(resource: PokemonDetailsResource(pokemon: pokemon))
        self.request?.execute(withCompletion: { details, error in
            guard error == nil else {
                self.errorMessage = error?.localizedDescription
                return
            }
            
            guard let pokemonDetails = details else {
                self.errorMessage = "No pokemon details received"
                return
            }
            
            self.pokemonDetails = pokemonDetails
            self.name = pokemonDetails.name
            self.id = "Nº".appendingFormat("%.3d", pokemonDetails.id)
           
            self.downloadImage()
            
            self.types = pokemonDetails.types.map({ $0.type.name })
            self.height = String(format: "%0.1f m", pokemonDetails.height / 10)
            self.weight = String(format: "%0.1f kg", pokemonDetails.weight / 10)
            self.order = String(pokemonDetails.order)
            self.experience = String(pokemonDetails.base_experience)
        })
        
        self.isLikedRequest = APIRequest(resource: LikeStatusResource(name: self.pokemon.name))
        self.isLikedRequest?.execute(withCompletion: { response, error in
            guard error == nil else {
                //TODO: This error needs to be handled. Outside of scope. 
                print("error: \(error!.localizedDescription)")
                return
            }
            
            if let webHookRequests = response {
                self.isLiked = webHookRequests.total > 0
            }
        })
    }
    
    private func downloadImage() {
        if let url = self.pokemonDetails?.sprites.front_default {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    private var likeRequest: APIRequest<LikePokemonResource>?
    
    func like() {
        
        if let pokemonDetails = self.pokemonDetails {
            let body = LikePokemonPayload(id: pokemonDetails.id, name: pokemonDetails.name)
            
            self.likeRequest = APIRequest(resource: LikePokemonResource())
            
            self.likeRequest?.execute(body: body, withCompletion: { response, error in
                self.isLiked = true
                guard error == nil else {
                    // There is error that the URL has no default content. The headers are set correctly and the same error appears in Postman. 
                    print("error \(error!.localizedDescription)")
                    return
                }
            })
        }
    }
    
    func removeLike() {
        // The network call is out of scope
        self.isLiked = false
    }

}
