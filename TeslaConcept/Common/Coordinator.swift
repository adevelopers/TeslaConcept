//
//  Coordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}
