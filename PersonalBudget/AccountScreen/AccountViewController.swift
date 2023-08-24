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

class AccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: AccountViewControllerDelegate?
    private let accountTypes = ["Cash", "Card", "Savings", "Other"]
    
    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var accountNameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Account name*"
        txtField.textField.placeholder = "Enter account name"
    
        return txtField
    }()
    
    private var accountTypeField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Account type"
        txtField.textField.placeholder = "Enter account type"
    
        return txtField
    }()
    
    private var accountTypePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private var balanceField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Balance*"
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
        
        accountTypePicker.dataSource = self
        accountTypePicker.delegate = self
        accountTypeField.textField.inputView = accountTypePicker
               
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
        
        removeErrorForField(field: balanceField)
        
        if accountName.isEmpty {
            showErrorForField(field: accountNameField, message: "You have to enter account name")
            return
        } else {
            removeErrorForField(field: accountNameField)
        }
        
        
        let newAccount = Account(accountName: accountName, accountType: accountType, openingBalance: openingBalance, expenses: [])
        
        if var existingUsers = UserFileManager.loadUsersData() {
            // Find and update the current user
            if let userIndex = existingUsers.firstIndex(where: { $0.username == currentUser.username }) {
                currentUser.accounts = existingUsers[userIndex].accounts
                currentUser.accounts.append(newAccount)
                existingUsers[userIndex] = currentUser
            }
            // Save the updated user data
            UserFileManager.saveUsersData(existingUsers)
        }

        UsersManager.shared.updateCurrentUser(currentUser)
        
        //UserFileManager.saveUsersData([currentUser])
        
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
    
    private func removeErrorForField(field: RoundedValidatedTextInput) {
        field.errorField.isHidden = true
        field.textField.layer.borderColor = UIColor.black.cgColor
        field.textField.layer.cornerRadius = 6
        field.textField.layer.borderWidth = 2
    }
    
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountTypes.count
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountTypes[row]
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountTypeField.textField.text = accountTypes[row]
    }

}
