//
//  CoordinatorDelegates.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


protocol ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator)
}

protocol CoordinatorDelegate: class {
    func viewControllerHasFinished()
}
