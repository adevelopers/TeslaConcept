//
//  Location.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 30.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import CoreLocation
import RealmSwift


class Location: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
          return "id"
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}


extension Location {
    func setCoordinate(_ coordinate2D: CLLocationCoordinate2D) {
        latitude = coordinate2D.latitude
        longitude = coordinate2D.longitude
    }
}

