//
//  LoginCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


protocol LoginFlow {
    func mainFlow()
    func registrationFlow()
}

enum LoginChildCoordinators {
    case main
    case registration
}

class LoginCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    
    private var childCoordinators: [LoginChildCoordinators: Coordinator] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        childCoordinators[.main] = MainCoordintor(navigationController: navigationController)
        childCoordinators[.registration] = RegistrationCoordinator(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let controller = LoginViewController(viewModel: viewModel)
        viewModel.flow = self
        navigationController.viewControllers = [controller]
        
        setAsRoot(navigationController)
    }
    
}

extension LoginCoordinator: LoginFlow {
    
    func mainFlow() {
        childCoordinators[.main]?.start()
    }
    
    func registrationFlow() {
        childCoordinators[.registration]?.start()
    }
    
}
