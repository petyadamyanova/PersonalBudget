//
//  AccountExpenseViewController.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 22.08.23.
//

import UIKit

class AccountExpenseViewController: UIViewController {
    var tableView: UITableView!
    let cellIdentifier = "Expense"
    var expenses: [Expense] = []
    var currentAccount: Account?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddExpenseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        
        if let account = UsersManager.shared.getCurrentAccount() {
            currentAccount = account
            
            if let expenses = currentAccount?.expenses, !expenses.isEmpty {
                self.expenses = expenses
                tableView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
                
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
                
        self.tableView = tableView
  }
    
    private func setupAddExpenseButton() {
        let accountAction = UIAction(title: "Add expense", handler: didTapAddExpenseButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: accountAction)
    }
    
    private func didTapAddExpenseButton(_ action: UIAction) {
        let expenseViewController = ExpenseViewController()
        expenseViewController.delegate = self
        navigationController?.pushViewController(expenseViewController, animated: true)
    }
}

extension AccountExpenseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let expenses = UsersManager.shared.getCurrentAccount()?.expenses else {
            return 0
        }
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = UsersManager.shared.getCurrentAccount()?.expenses?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = expense?.name
        content.secondaryText = "Amount: \(expense?.amount ?? 0)"
        cell.contentConfiguration = content
        
        return cell
    }
}

extension AccountExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = "Expenses: "
        return label
    }
}

extension AccountExpenseViewController: ExpenseViewControllerDelegate {
    func didAddExpense(_ expense: Expense) {
        expenses.append(expense)
        self.tableView.reloadData()
        //print(expenses.first?.name)
    }
}
