//
//  RegistraionCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


protocol RegistrationFlow {
    func mainFlow()
}

class RegistrationCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    
    private var coordinator: MainCoordintor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coordinator = MainCoordintor(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = RegistrationViewModel()
        viewModel.flow = self
        navigationController.pushViewController(RegistrationViewController(viewModel: viewModel), animated: true)
    }
    
}

extension RegistrationCoordinator: RegistrationFlow {
    
    func mainFlow() {
        coordinator.start()
    }
    
}
