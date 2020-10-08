//
//  User.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import RealmSwift


class User: Object {
    
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var lastLoggedDate = Date()
    
    override static func primaryKey() -> String? {
          return "login"
    }
}
