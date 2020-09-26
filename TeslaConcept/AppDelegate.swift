//
//  AppDelegate.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 22.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var store: Store = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCNV4DOMwlSfGN6JLRwHQi4PyxdytswIbY")
        
        window = UIWindow()
        
        assembly()
        return true
    }


    func assembly() {
        let splitController = SplitViewController()
        splitController.viewControllers = [
            LeftViewController(viewModel: LeftViewModel.init(didTapTrack: store.didTapTrackLocation,
                                                             didTapCurrent: store.didTapCurrentLocation)),
            GoogleMapsViewController(viewModel: MapViewModel(didTapTrack: store.didTapTrackLocation,
                                                             didTapCurrent: store.didTapCurrentLocation))
//            RightViewController(viewModel: MainViewModel())
        ]
        
        window?.rootViewController = splitController
        window?.makeKeyAndVisible()
        
    }
}

extension UIViewController {
    internal func setDarkTheme() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }
}
