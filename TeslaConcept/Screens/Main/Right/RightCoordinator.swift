//
//  RightCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


protocol RightFlow {
    func showMusicTracks()
}

enum RightChildCoordinators {
    case musicTracks
}

class RightCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    
    private var childCoordinators: [RightChildCoordinators: Coordinator] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators[.musicTracks] = MusicTracksCoordinator(controller: DIContainer.shared.rightController)
    }
    
    func start() {}
}


extension RightCoordinator: RightFlow {
    
    func showMusicTracks() {
        print("showMusicTracks()")
        childCoordinators[.musicTracks]?.start()
    }
    
}


