//
//  MainCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


enum MainChildCoordinator {
    case left
    case right
}

class MainCoordintor: FlowCoordinator {
    var navigationController: UINavigationController
    
    private var childCoordinators: [MainChildCoordinator: Coordinator] = [:]
    
    private lazy var container: DIContainer = {
        return DIContainer.shared
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let rightCoordinator = RightCoordinator(navigationController: navigationController)
        container.rightController.viewModel.flow = rightCoordinator
        childCoordinators[.right] = rightCoordinator
    }
    
    func start() {
        
        setAsRoot(container.mainController)
    }
    
    
}

