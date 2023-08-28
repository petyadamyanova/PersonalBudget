//
//  LogInViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

final class LogInViewController: UIViewController {
    weak var delegate: LogInViewControllerDelegate?
    
    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    private var usernameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "UserName"
        txtField.textField.placeholder = "Enter username"
    
        return txtField
    }()
    
    private var passwordField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Password"
        txtField.textField.placeholder = "Enter password"
        txtField.textField.isSecureTextEntry = true
    
        return txtField
    }()
    
    private var submitButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        
        var buttonConfiguration = UIButton.Configuration.tinted()
        buttonConfiguration.cornerStyle = .large
        button.configuration = buttonConfiguration
        
        return button
    }()
    
    private var registerButton = {
        let button = UIButton()
        button.setTitle("For registration click here", for: .normal)
        
        var buttonConfiguration = UIButton.Configuration.tinted()
        buttonConfiguration.cornerStyle = .large
        button.configuration = buttonConfiguration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDismissButton()
        setupSubmitButton()
        setupRegisterButton()
        addSubviews()
        addStackViewConstraints()
    }
    
    private func setupDismissButton() {
        let cancelAction = UIAction(handler: didTapCancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: cancelAction)
    }
    
    private func setupSubmitButton() {
        let submitAction = UIAction(handler: didtapSubmitButton)
        submitButton.addAction(submitAction, for: .touchUpInside)
    }
    
    private func setupRegisterButton() {
        let registerAction = UIAction(handler: didtapRegisterButton)
        registerButton.addAction(registerAction, for: .touchUpInside)
    }
    
    private func didtapRegisterButton(_ action: UIAction) {
        guard let navigationController = navigationController else {
            return
        }
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.start()
    }
    
    private func didTapCancelButton(_ action: UIAction) {
        dismiss(animated: true)
    }
    
    private func didtapSubmitButton(_ action: UIAction) {
        
        guard let username = usernameField.textField.text,
              let password = passwordField.textField.text else {
            return
        }
            
        guard let users = UserFileManager.loadUsersData() else {
            return
        }
        
        if users.first(where: { $0.username != username }) == nil {
            showErrorForField(field: usernameField, message: "Username not found!")
        }else{
            removeErrorForField(field: usernameField)
        }
        
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            
            UsersManager.shared.addUser(user)
            UsersManager.shared.setCurrentUser(user)
            
            let mainViewController = MainViewController()
            let navController = UINavigationController(rootViewController: mainViewController)
            navController.modalPresentationStyle = .fullScreen
            navigationController?.present(navController, animated: true)
            delegate?.didLogin(username)
        } else if users.first(where: { $0.password != password }) != nil {
            showErrorForField(field: passwordField, message: "Password is incorect!")
        }
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(submitButton)
        stackView.addArrangedSubview(registerButton)
    }
    
    private func addStackViewConstraints() {
        view.addConstraints([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func showErrorForField(field: RoundedValidatedTextInput, message: String) {
        field.errorField.isHidden = false
        field.textField.layer.borderColor = UIColor.red.cgColor
        field.textField.layer.borderWidth = 0.5
        field.errorField.text = message
    }
    
    private func removeErrorForField(field: RoundedValidatedTextInput) {
        field.errorField.isHidden = true
        field.textField.layer.borderColor = UIColor.black.cgColor
        field.textField.layer.cornerRadius = 6
        field.textField.layer.borderWidth = 2
    }
}

protocol LogInViewControllerDelegate: AnyObject {
    func didLogin(_ username: String)
}

