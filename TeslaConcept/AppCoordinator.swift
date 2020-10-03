//
//  AppCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import Combine


enum AppCoordinators {
    case login
    case main
}

class AppCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [AppCoordinators: Coordinator] = [:]
    
    private var cancelables: [AnyCancellable] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    
        childCoordinators[.login] = LoginCoordinator(navigationController: navigationController)
        childCoordinators[.main] = MainCoordintor(navigationController: navigationController)
        setupSubscriptions()
    }
    
    
    private func setupSubscriptions() {
        Store.shared.didTapLogout
            .sink(receiveValue: loginFlow)
            .store(in: &cancelables)
            
    }
    
    func start() {
        if UserDefaults.standard.authorized {
            mainFlow()
        } else {
            loginFlow()
        }
    }
    
    private func mainFlow() {
        childCoordinators[.main]?.start()
    }
    
    private func loginFlow() {
        childCoordinators[.login]?.start()
    }
}


