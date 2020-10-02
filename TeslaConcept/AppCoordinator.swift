//
//  AppCoordinator.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class AppCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // если не авторизаованы то Login Flow
        // иначе mainFlow
        mainFlow()
    }
    
    private func mainFlow() {
        let store = Store.shared
        let splitController = SplitViewController()
        splitController.viewControllers = [
            LeftViewController(viewModel: LeftViewModel.init(didTapTrack: store.didTapTrackLocation,
                                                             didTapCurrent: store.didTapCurrentLocation,
                                                             didTapStartTrack: store.didTapStartTrack,
                                                             didTapStopTrack: store.didTapStopTrack,
                                                             didTapPreviousTrack: store.didTapPreviousTrack,
                                                             speed: store.speed
                                                             )),
            RightViewController(viewModel: MapViewModel(didTapTrack: store.didTapTrackLocation,
                                                             didTapCurrent: store.didTapCurrentLocation,
                                                             didTapStartTrack: store.didTapStartTrack,
                                                             didTapStopTrack: store.didTapStopTrack,
                                                             didTapPreviousTrack: store.didTapPreviousTrack,
                                                             speed: store.speed
                                                             ))
        ]
        
        
        setAsRoot(splitController)
        
    }
    
    
    private func setAsRoot(_ controller: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = controller
    }
}


