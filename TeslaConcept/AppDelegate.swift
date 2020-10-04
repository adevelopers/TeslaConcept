//
//  AppDelegate.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 22.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bluredView = UIVisualEffectView()
    
    var store: Store = .init()
    lazy var appCoordinator: Coordinator = {
        AppCoordinator(navigationController: UINavigationController())
    }()
    
    
    override init() {
        super.init()
        setupRealm()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCNV4DOMwlSfGN6JLRwHQi4PyxdytswIbY")
        
        assembly()
        return true
    }


    func assembly() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        appCoordinator.start()
    }
    
    private func setupRealm() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        print("🧊 Realm path:", realm.configuration.fileURL?.absoluteString ?? "")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        guard let window = window else { return }
        
        if !bluredView.isDescendant(of: window) {
            let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
            bluredView = UIVisualEffectView(effect: blurEffect)
            bluredView.frame = window.bounds
            print("setBluredView")
            window.addSubview(bluredView)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        bluredView.removeFromSuperview()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        bluredView.removeFromSuperview()
    }
}

extension UIViewController {
    internal func setDarkTheme() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }
}
