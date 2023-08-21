//
//  RegisterViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var nameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Name"
        txtField.textField.placeholder = "Enter name"
    
        return txtField
    }()
    
    private var usernameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "UserName"
        txtField.textField.placeholder = "Enter username"
        txtField.errorField.text = "Error"
    
        return txtField
    }()
    
    private var emailField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Email"
        txtField.textField.placeholder = "Enter email"
    
        return txtField
    }()
    
    private var passwordField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Password"
        txtField.textField.placeholder = "Enter password"
        txtField.textField.isSecureTextEntry = true
    
        return txtField
    }()
    
    private var secondPasswordField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Repeat the password"
        txtField.textField.placeholder = "Enter password"
        txtField.textField.isSecureTextEntry = true
    
        return txtField
    }()
    
    private var registerButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        
        var buttonConfiguration = UIButton.Configuration.tinted()
        buttonConfiguration.cornerStyle = .large
        button.configuration = buttonConfiguration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubmitButton()
        addSubviews()
        addStackViewConstraints()
        
    }
    
    private func setupSubmitButton() {
        let registerAction = UIAction(handler: didtapRegisterButton)
        registerButton.addAction(registerAction, for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(secondPasswordField)
        stackView.addArrangedSubview(registerButton)
    }
    
    private func addStackViewConstraints() {
        view.addConstraints([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func didtapRegisterButton(_ action: UIAction) {
        guard let name = nameField.textField.text,
              let email = emailField.textField.text,
              let username = usernameField.textField.text,
              let password = passwordField.textField.text,
              let password2 = secondPasswordField.textField.text else {
                  return
              }
        
        if name.isEmpty {
            showErrorForField(field: nameField, message: "You have to enter your name here")
        } else {
            removeErrorForField(field: nameField)
        }
        
        if !isValidEmail(email) {
            showErrorForField(field: emailField, message: "Invalid email format")
            return
        } else {
            removeErrorForField(field: emailField)
        }
        
        if username.count < 3 {
            showErrorForField(field: usernameField, message: "The username has to be at least 3 symbols!")
            return
        } else {
            removeErrorForField(field: usernameField)
        }
        
        if password != password2 {
            showErrorForField(field: secondPasswordField, message: "The passwords don't match!")
            return
        } else {
            removeErrorForField(field: secondPasswordField)
        }
        
        let user = User(name: name, email: email, username: username, password: password, accounts: [])
        
        UsersManager.shared.addUser(user)
        UsersManager.shared.setCurrentUser(user)
        
        encodeAndStoreUserData([user])
        
        
        let mainViewController = MainViewController()
        let navController = UINavigationController(rootViewController: mainViewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true)
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func encodeAndStoreUserData(_ users: [User]) {
        let encoder = JSONEncoder()
        do {
            let encodedUsers = try encoder.encode(users)
            UserDefaults.standard.set(encodedUsers, forKey: "userData")
        } catch {
            print("Error encoding and storing user data: \(error)")
        }
    }
}