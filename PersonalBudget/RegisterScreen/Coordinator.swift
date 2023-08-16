//
//  Coordinator.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
        
    func start()
    func addChild(child: Coordinator)
    func removeChild(child: Coordinator)
}

extension Coordinator {
    func addChild(child: Coordinator) {
        childCoordinators.append(child)
    }
        
    func removeChild(child: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0 !== child
        }
    }
}

