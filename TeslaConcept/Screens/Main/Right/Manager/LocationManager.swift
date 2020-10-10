//
//  LocationManager.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 10.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa


final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let location: BehaviorRelay<CLLocation?> = .init(value: nil)
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        return locationManager
    }()
    
    private override init() {
        super.init()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation(){
        locationManager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
