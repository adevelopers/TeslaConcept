//
//  MusicTracksCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class MusicTracksCoordinator: Coordinator {
    
    private var controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func start() {
        if let presentedController = controller.presentedViewController {
            presentedController.dismiss(animated: true, completion: showModalController)
        } else {
            showModalController()
        }
    }
    
    private func showModalController() {
        print(showModalController)
        let container = DIContainer.shared
        controller.present(container.musicTracksController, animated: true)
    }
}
