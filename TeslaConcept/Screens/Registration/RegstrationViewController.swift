//
//  RegstrationViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 03.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import VanillaConstraints


final class RegistrationViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.text = "Регистрация"
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
        
    private lazy var registraionButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .backgroundPanel
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            loginField,
            passwordField,
            errorLabel,
            registraionButton
        ])
        stack.axis = .vertical
        
        stack.spacing = 16
        return stack
    }()
    
    private var viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        verticalStack
            .add(to: view)
            .centerY(to: \.centerYAnchor)
            .centerX(to: \.centerXAnchor)
            .width(300)
        
        [loginField, passwordField, registraionButton].forEach { $0.addHeight(48) }
    }
    
    @objc
    private func didTap() {
        
        viewModel.login.send(loginField.text)
        viewModel.password.send(passwordField.text)
        
        viewModel.didTapRegistration.send()
    }
    
}
