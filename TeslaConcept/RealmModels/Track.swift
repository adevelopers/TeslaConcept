//
//  Track.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 30.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import RealmSwift


class Track: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    let points = List<Location>()
    
    override static func primaryKey() -> String? {
          return "id"
    }
}
