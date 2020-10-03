//
//  LoginViewModel.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import Combine


class LoginViewModel {
    
    var flow: LoginFlow?
    
    let login: CurrentValueSubject<String?, Never> = .init(nil)
    let password: CurrentValueSubject<String?, Never> = .init(nil)
    let loginError: CurrentValueSubject<String?, Never> = .init(nil)
    let didTapSignIn: PassthroughSubject<Void, Never> = .init()
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        didTapSignIn
            .combineLatest(login, password)
            .map { ($0.1, $0.2) }
            .sink(receiveValue: fieldsValidation)
            .store(in: &cancellables)
            
    }
    
    private func md5(_ password: String?) -> String {
        return "12345"
    }
    
    func fieldsValidation( _ login: String?, _ password: String?) {
        print("login: \(login) password: \(password)")
        
        guard let login = login else {
            loginError.send("Заполните поле логин")
            return
        }
        
        if login.count < 3 {
            loginError.send("Логин должен быть длинее 3-х символов")
            return
        } else if login.count > 255 {
            loginError.send("Пароль должен быть разумных размеров")
            return
        } else {
            loginError.send(nil)
        }
        
        guard let password = password else {
            loginError.send("Заполните поле пароль")
            return
        }
        
        if password.count < 5 {
            loginError.send("Пароль должен быть длинее 4 символов")
            return
        } else if password.count > 255 {
            loginError.send("Пароль должен быть разумных размеров")
            return
        } else {
            loginError.send(nil)
        }
        
        if
            loginError.value == nil,
            login == "admin",
            password == "12345"
        {
//            loginError.send(nil)
            UserDefaults.standard.authorized = true
            flow?.mainFlow()
        } else {
            loginError.send("Логин или пароль введены неверно")
        }
        
    }
    
}
