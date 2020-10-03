//
//  LoginViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import Combine
import VanillaConstraints


final class LoginViewController: UIViewController {
    
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
    
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .backgroundPanel
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: LoginViewModel
    private var cancellables: [AnyCancellable] = []
    
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
            .width(200)
            .height(48)
        
        passwordField
            .add(to: view)
            .centerX(to: \.centerXAnchor)
            .top(to: \.bottomAnchor, of: loginField, constant: 16)
            .width(200)
            .height(48)
        
        errorLabel
            .add(to: view)
            .top(to: \.bottomAnchor, of: passwordField, constant: 4)
            .centerX(to: \.centerXAnchor)
            .width(200)
        
        loginButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: errorLabel, constant: 16)
            .centerX(to: \.centerXAnchor)
            .width(200)
            .height(48)
        
        passwordField
            .addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordField
            .addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        
        loginField
            .addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        loginField
            .addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        
        

    }
    
    
    private func setupSubscriptions() {
        viewModel.loginError
            .assign(to: \.text, on: errorLabel)
            .store(in: &cancellables)
    }
    
    @objc
    private func beginEditing(_ field: UITextField) {
        viewModel.loginError.send(nil)
    }
    
    @objc
    private func editingChanged(_ field: UITextField) {
        switch field {
        case loginField:
            viewModel.login.send(field.text)
        case passwordField:
            viewModel.password.send(field.text)
        default:
            ()
        }
        
    }
    
    @objc private func editingLoginChanged(_ field: UITextField) {
        viewModel.password.send(field.text)
    }
    
    @objc
    private func didTap(_ button: UIButton) {
        switch button {
        case loginButton:
            viewModel.login.send(loginField.text?.lowercased())
            viewModel.password.send(passwordField.text)
            viewModel.didTapSignIn.send()
        default:
            ()
        }
    }
    
}
