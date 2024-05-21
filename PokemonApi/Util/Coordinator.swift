//
//  Coordinator.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import Foundation


protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }
    func start() -> Void
}

extension Coordinator {
    /// Add a child coordinator to the parent
    func addChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
}
