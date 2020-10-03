//
//  AppCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit

enum AppCoordinators {
    case main
}

class AppCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [AppCoordinators: Coordinator] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    
        
        childCoordinators[.main] = MainCoordintor(navigationController: navigationController)
    }
    

    
    func start() {
        // если не авторизаованы то Login Flow
        // иначе mainFlow
        mainFlow()
    }
    
    private func mainFlow() {
        childCoordinators[.main]?.start()
    }
    
}


