//
//  ExpenseViewController.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 22.08.23.
//

import UIKit

protocol ExpenseViewControllerDelegate: AnyObject {
    func didAddExpense(_ expense: Expense)
}

class ExpenseViewController: UIViewController {
    weak var delegate: ExpenseViewControllerDelegate?
    
    private var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var expenseNameField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Name"
        txtField.textField.placeholder = "Enter expense name"
    
        return txtField
    }()
    
    private var expenseDateField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Date"
        txtField.textField.placeholder = "Enter expense date"
    
        return txtField
    }()
    
    private var expenseAmountField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Amount"
        txtField.textField.placeholder = "Enter expense amount"
    
        return txtField
    }()
    
    private var expenseCategoryField: RoundedValidatedTextInput = {
        let txtField = RoundedValidatedTextInput()
        txtField.label.text = "Category"
        txtField.textField.placeholder = "Enter expense category"
    
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
        guard var currentAccount = UsersManager.shared.getCurrentAccount() else {
            return
        }
        
        guard var currentUser = UsersManager.shared.getCurrentUser() else {
            return
        }
        
        guard let expenseName = expenseNameField.textField.text,
              let expenseDate = expenseDateField.textField.text,
              let expenseAmount = expenseAmountField.textField.text,
              let expenseCategory = expenseCategoryField.textField.text,
              let amount = Double(expenseAmount) else {
            return
        }
        
        let newExpense = Expense(date: expenseDate, name: expenseName, amount: amount, category: expenseCategory)

        currentAccount.expenses.append(newExpense)
        
        if var users = UserFileManager.loadUsersData() {
            if let userIndex = users.firstIndex(where: { $0.username == currentUser.username }) {
                currentUser.accounts = users[userIndex].accounts
                if let accountIndex = currentUser.accounts.firstIndex(where: { $0.accountName == currentAccount.accountName }) {
                    currentUser.accounts[accountIndex] = currentAccount
                    users[userIndex] = currentUser
                    UserFileManager.saveUsersData(users)
                }
            }
        }
        
        delegate?.didAddExpense(newExpense)
        navigationController?.popViewController(animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(stackView)

        stackView.addArrangedSubview(expenseNameField)
        stackView.addArrangedSubview(expenseDateField)
        stackView.addArrangedSubview(expenseAmountField)
        stackView.addArrangedSubview(expenseCategoryField)
        stackView.addArrangedSubview(submitButton)
    }

    private func addStackViewConstraints() {
        view.addConstraints([
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }

}


