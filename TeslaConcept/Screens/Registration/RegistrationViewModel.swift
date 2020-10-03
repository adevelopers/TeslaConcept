//
//  RegistrationViewModel.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import Combine
import RealmSwift


class RegistrationViewModel {
    
    let login: CurrentValueSubject<String?, Never> = .init(nil)
    let password: CurrentValueSubject<String?, Never> = .init(nil)
    
    let didTapRegistration: PassthroughSubject<Void, Never> = .init()
    
    var flow: RegistrationFlow?
    
    private var realm: Realm = { try! Realm() }()
    private var cancellables: [AnyCancellable] = []
    
    init() {
    
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        didTapRegistration
            .combineLatest(login, password)
            .map { ($0.1, $0.2) }
            .filter({ $0.0 != nil && $0.1 != nil })
            .map { ($0.0!, $0.1!) }
            .filter({ $0.0.count > 2 && $0.1.count >= 5 })
            .map(saveToDB)
            .sink(receiveValue: authorizeUser)
            .store(in: &cancellables)
    }
    
    private func saveToDB(login: String, password: String) {
        if
            let user = realm.objects(User.self)
            .filter(NSPredicate(format: "login = %@ ", login.lowercased()))
            .first
        {
            try? realm.write {
                user.password = password
            }
        } else {
            addNewUser(login: login, password: password)
        }
    }
    
    private func addNewUser(login: String, password: String) {
        let user = User()
        user.login = login.lowercased()
        user.password = password
        
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("\(error)")
        }
    }
    
    private func authorizeUser() {
        print("registration success")
        self.flow?.mainFlow()
    }
}