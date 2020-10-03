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
}


class LoginCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    
    private var childCoordinator: MainCoordintor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = MainCoordintor(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let controller = LoginViewController(viewModel: viewModel)
        viewModel.flow = self
        setAsRoot(controller)
    }
    
}

extension LoginCoordinator: LoginFlow {
    
    func mainFlow() {
        childCoordinator.start()
    }
    
}
