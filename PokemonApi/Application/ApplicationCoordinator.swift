//
//  ApplicationCoordinator.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import UIKit

class ApplicationCoordinator: Coordinator, PokemonListControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: CoordinatorDelegate?
    
    let window: UIWindow
    
    private lazy var rootController: PokemonListController = {
        let controller = PokemonListController(viewModel: PokemonListViewModel())
        controller.title = NSLocalizedString("Pokedex", comment: "")
        controller.delegate = self
        return controller
    }()

    private lazy var navigationController: UINavigationController = {
        return UINavigationController(rootViewController: self.rootController)
    }()
    
    //MARK: Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        self.window.rootViewController = self.navigationController
    }
    
    //MARK: PokemonListControllerDelegate
    
    func pokemonList(controller: PokemonListController, didSelect pokemon: PokemonViewModel) {
        let controller = PokemonDetailsController(pokemon: pokemon)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
}
