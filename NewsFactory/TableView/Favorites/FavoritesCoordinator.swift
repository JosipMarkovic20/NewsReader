//
//  FavoritesCoordinator.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class FavoritesCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var presenter: UINavigationController?
    let viewModel: FavoritesViewModel
    let viewController: FavoritesTableViewController
    
    init(presenter :UINavigationController?) {
        self.presenter = presenter
        viewModel = FavoritesViewModel()
        viewController = FavoritesTableViewController(viewModel: viewModel)
    }
    
    func start() {
    }
    
}
