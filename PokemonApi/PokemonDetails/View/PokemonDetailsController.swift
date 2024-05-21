//
//  PokemonDetailsController.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import UIKit
import Combine

class PokemonDetailsController: UIViewController {
    
    private lazy var pokemonView: PokemonDetailsView = {
        let view = PokemonDetailsView()
        return view
    }()
    
    let pokemon: PokemonViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var toggleLikeButton: UIBarButtonItem  = {
        return UIBarButtonItem(title: "Like", style: .done, target: self, action: #selector(toggleLikeButtonTapped(sender:)))
    }()
    
    //MARK: Initialization
    
    init(pokemon: PokemonViewModel) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        
        self.pokemon.$name.sink { newName in
            self.pokemonView.nameLabel.text = newName
        }
        .store(in: &subscriptions)
        
        self.pokemon.$image.sink { [weak self] image in
            DispatchQueue.main.async {
                self?.pokemonView.imageView.image = image
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$id.sink { [weak self] pokemonId in
            self?.pokemonView.idLabel.text = pokemonId
        }
        .store(in: &subscriptions)
        
        self.pokemon.$types.sink { [weak self] types in
            for type in types {
                self?.pokemonView.add(type: type)
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$height.sink { [weak self] height in
            DispatchQueue.main.async {
                self?.pokemonView.heightView.valueLabel.text = height
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$weight.sink { [weak self] weight in
            DispatchQueue.main.async {
                self?.pokemonView.weightView.valueLabel.text = weight
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$experience.sink { [weak self] experience in
            self?.pokemonView.experienceView.valueLabel.text = experience
        }
        .store(in: &subscriptions)
        
        self.pokemon.$order.sink { [weak self] order in
            self?.pokemonView.orderView.valueLabel.text = order
        }
        .store(in: &subscriptions)
        
        self.pokemon.$isLiked.sink { [weak self] status in
            if let isLiked = status {
                DispatchQueue.main.async {
                    self?.toggleLikeButton.title = isLiked ? "Remove like" : "Like"
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
    //MARK: View lifecycle
    
    override func loadView() {
        self.view = self.pokemonView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.toggleLikeButton
    }
    
    //MARK: Actions
    
    @objc func toggleLikeButtonTapped(sender: UIBarButtonItem) {
        
        if let isLiked = self.pokemon.isLiked, isLiked {
            self.pokemon.removeLike()
        } else {
            self.pokemon.like()
        }
    }
    
}
