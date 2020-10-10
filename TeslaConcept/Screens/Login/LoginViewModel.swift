//
//  LoginViewModel.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import RealmSwift

import RxSwift
import RxCocoa


class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    weak var flow: LoginFlow?
    
    let login: BehaviorRelay<String?> = .init(value: nil)
    let password: BehaviorRelay<String?> = .init(value: nil)
    
    let loginError: BehaviorRelay<String?> = .init(value: nil)
    let signInEnabled: BehaviorRelay<Bool> = .init(value: false)
    
    let didTapSignIn: PublishRelay<Void> = .init()
    let didTapRegistration: PublishRelay<Void> = .init()
    
    private var realm: Realm = { try! Realm() }()
    
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        
        let loginAndPasswordShared = Observable.combineLatest(login.compactMap({ $0 }),
                                                              password.compactMap({ $0 }))
            .share()
        
        loginAndPasswordShared
            .map({ $0.0.count >= 3 && $0.1.count >= 5}).bind(to: signInEnabled)
            .disposed(by: disposeBag)
        
        didTapSignIn
            .withLatestFrom(loginAndPasswordShared)
            .subscribe(onNext: fieldsValidation)
            .disposed(by: disposeBag)
        
        didTapRegistration
            .subscribe(onNext: runRegistrationFlow)
            .disposed(by: disposeBag)
        
    }
    
    private func md5(_ password: String?) -> String {
        return "12345"
    }
    
    func fieldsValidation( _ login: String?, _ password: String?) {
        print("login: \(login) password: \(password)")
        
        guard let login = login else {
            loginError.accept("Заполните поле логин")
            return
        }
        
        if login.count < 3 {
            loginError.accept("Логин должен быть длинее 3-х символов")
            return
        } else if login.count > 255 {
            loginError.accept("Пароль должен быть разумных размеров")
            return
        } else {
            loginError.accept(nil)
        }
        
        guard let password = password else {
            loginError.accept("Заполните поле пароль")
            return
        }
        
        if password.count < 5 {
            loginError.accept("Пароль должен быть длинее 4 символов")
            return
        } else if password.count > 255 {
            loginError.accept("Пароль должен быть разумных размеров")
            return
        } else {
            loginError.accept(nil)
        }
        
        
        if
            loginError.value == nil,
            let user = realm.objects(User.self)
                .filter(NSPredicate(format: "login = %@ and password = %@", login, password))
                .first
        {
            print("✅ Вы авторизованы как \(user.login)")
            UserDefaults.standard.authorized = true
            flow?.mainFlow()
        } else {
            loginError.accept("Логин или пароль введены неверно")
        }
        
    }
    
    private func runRegistrationFlow() {
        flow?.registrationFlow()
    }
}
