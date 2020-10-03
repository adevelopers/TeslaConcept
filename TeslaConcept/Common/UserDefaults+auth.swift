//
//  UserDefaults+auth.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation


extension UserDefaults {
    var authorized: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
