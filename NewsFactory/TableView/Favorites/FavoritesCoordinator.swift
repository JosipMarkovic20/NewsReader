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
    
    var navigationController: UINavigationController?
    let viewModel: FavoritesViewModel
    let viewController: FavoritesTableViewController
    
    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
        viewModel = FavoritesViewModel()
        viewController = FavoritesTableViewController(viewModel: viewModel)
    }
    
    func start() {
    }
    
}
