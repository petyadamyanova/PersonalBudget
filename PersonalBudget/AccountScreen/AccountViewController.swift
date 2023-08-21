//
//  AccountViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func didAddAccount(_ account: Account)
}

class AccountViewController: UIViewController {
    weak var delegate: AccountViewControllerDelegate?
    
    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var accountNameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Account name"
        txtField.textField.placeholder = "Enter account name"
    
        return txtField
    }()
    
    private var accountTypeField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Account type"
        txtField.textField.placeholder = "Enter account type"
    
        return txtField
    }()
    
    private var balanceField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Balance"
        txtField.textField.placeholder = "Enter balance"
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubmitButton()
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
    
    private func didTapCancelButton(_ action: UIAction) {
        dismiss(animated: true)
    }
    
    private func didtapSubmitButton(_ action: UIAction) {
        guard var currentUser = UsersManager.shared.getCurrentUser() else {
            return
        }
        
        guard let accountName = accountNameField.textField.text,
              let accountType = accountTypeField.textField.text,
              let balance = balanceField.textField.text,
              let openingBalance = Int(balance) else {
            showErrorForField(field: balanceField, message: "You have to enter number here!")
            return
        }
        
        
        
        let newAccount = Account(accountName: accountName, accountType: accountType, openingBalance: openingBalance)
        
        currentUser.accounts.append(newAccount)
        UsersManager.shared.updateCurrentUser(currentUser)
        
        saveUserData([currentUser])
        
        delegate?.didAddAccount(newAccount)
        navigationController?.popViewController(animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(stackView)

        stackView.addArrangedSubview(accountNameField)
        stackView.addArrangedSubview(accountTypeField)
        stackView.addArrangedSubview(balanceField)
        stackView.addArrangedSubview(submitButton)
        }

    private func addStackViewConstraints() {
        view.addConstraints([
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    /*func saveUserData(_ user: User) {
        do {
            let encoder = JSONEncoder()
            let encodedUser = try encoder.encode(user)
            UserDefaults.standard.set(encodedUser, forKey: "userData")
        } catch {
            print("Error encoding user data: \(error)")
            
        }
    }*/
    
    private func saveUserData(_ users: [User]) {
        let encoder = JSONEncoder()
        do {
            let encodedUsers = try encoder.encode(users)
            UserDefaults.standard.set(encodedUsers, forKey: "userData")
        } catch {
            print("Error encoding and storing user data: \(error)")
        }
    }
    
    private func showErrorForField(field: RoundedValidatedTextInput, message: String) {
        field.errorField.isHidden = false
        field.textField.layer.borderColor = UIColor.red.cgColor
        field.textField.layer.borderWidth = 0.5
        field.errorField.text = message
    }

}
