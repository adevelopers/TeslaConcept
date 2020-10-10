//
//  LoginViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import VanillaConstraints


final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var loginField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .backgroundPanel
        field.placeholder = "Login"
        field.textColor = .white
        field.layer.cornerRadius = 8
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .backgroundPanel
        field.placeholder = "Password"
        field.textColor = .white
        field.isSecureTextEntry = true
        field.layer.cornerRadius = 8
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signInButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .backgroundPanel
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .disabled)
        return button
    }()
    
    private lazy var registraionButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .backgroundPanel
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private var viewModel: LoginViewModel
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        titleLabel.text = "Авторизация"
        
        titleLabel
            .add(to: view)
            .top(to: \.topAnchor, constant: 100)
            .centerX(to: \.centerXAnchor)
        
        loginField
            .add(to: view)
            .centerX(to: \.centerXAnchor)
            .top(to: \.bottomAnchor, of: titleLabel, constant: 48)
            .width(300)
            .height(48)
        
        passwordField
            .add(to: view)
            .centerX(to: \.centerXAnchor)
            .top(to: \.bottomAnchor, of: loginField, constant: 16)
            .width(300)
            .height(48)
        
        errorLabel
            .add(to: view)
            .top(to: \.bottomAnchor, of: passwordField, constant: 4)
            .centerX(to: \.centerXAnchor)
            .width(300)
        
        signInButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: errorLabel, constant: 16)
            .centerX(to: \.centerXAnchor)
            .width(300)
            .height(48)
        
        registraionButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: signInButton, constant: 48)
            .centerX(to: \.centerXAnchor)
            .width(300)
            .height(48)
        
    }
    
    
    private func setupSubscriptions() {
        
        disposeBag.insert([
            loginField.rx.text
                .bind(to: viewModel.login),
            passwordField.rx.text
                .bind(to: viewModel.password),
            viewModel.loginError
                .bind(to: errorLabel.rx.text),
            viewModel.signInEnabled
                .bind(to: signInButton.rx.isEnabled),
            signInButton.rx.tap
                .bind(to: viewModel.didTapSignIn),
            registraionButton.rx.tap
                .bind(to: viewModel.didTapRegistration)
        ])
    }
    
}
