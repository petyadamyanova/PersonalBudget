//
//  RegisterCoordinator.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import Foundation
import UIKit

final class RegisterCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let registerViewController = RegisterViewController()
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
}
