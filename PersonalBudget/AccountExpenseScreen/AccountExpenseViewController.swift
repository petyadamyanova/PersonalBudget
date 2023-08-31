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
    var currentAccount: Account
    private var filteredExpenses: [Expense] = []

    init(currentAccount: Account) {
        tableView = UITableView()
        self.currentAccount = currentAccount
        super.init(nibName: nil, bundle: nil)
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddExpenseButton()
        
        configureTableView()
        
        if let account = UsersManager.shared.getCurrentAccount() {
            currentAccount = account
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
                
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.isHidden = false
  }
    
    private func setupAddExpenseButton() {
        let accountAction = UIAction(title: "Add expense", handler: didTapAddExpenseButton)
        let currencyAction = UIAction(title: "Currency", handler: didTapCurrencyButton)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(primaryAction: accountAction), UIBarButtonItem(primaryAction: currencyAction)]
    }
    
    private func didTapAddExpenseButton(_ action: UIAction) {
        let expenseViewController = ExpenseViewController()
        expenseViewController.delegate = self
        navigationController?.pushViewController(expenseViewController, animated: true)
    }
    
    private func didTapCurrencyButton(_ action: UIAction) {
        // here we
    }
    
    /*func updateAccountCurrency(with currency: String) {
        let endpoint = "http://data.fixer.io/api/latest?access_key=cd0e1600b61c01035ad8b987c70c46c5&symbols=USD,CAD,JPY,BGN,RUB,GBP"


        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: URL(string: endpoint)!)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    //to do: Ui show error
                    return
                }


                guard let currencyDTO = try? JSONDecoder().decode(CurrencyDTO.self, from: data) else {
                    // to do: ui show something
                    return
                }
                
                guard let currentUserAccount = UsersManager.shared.currentUser else {
                    return
                }

                guard let accountIndex = currentUserAccount.accounts.firstIndex(where: { $0.accountName == currentAccount.accountName }) else {
                    return
                }
                
                guard let rate = currencyDTO.rates[currency] else {
                    return
                }
                
                guard let currentAccount = UsersManager.shared.currentAccount else{
                    return
                }
                
                let toEURRate = currencyDTO.rates[currentUserAccount.currency.rawValue] ?? 1.0
                
                let newTransactions: [Expense] = currentAccount.expenses.map { expense in
                    Expense(date: expense.date, name: expense.name, amount: expense.amount / toEURRate * rate, category: expense.category)
                }
                
                UsersManager.shared.currentAccount?.expenses = 
                    //.expenses = newTransactions
                
                UsersManager.currentUser?.accounts[accountIndex].openingBalance /= toEURRate
                UsersManager.currentUser?.accounts[accountIndex].openingBalance *= rate
                
                guard let currency = Currency(rawValue: currency) else {
                    return
                }
                
                UsersManager.currentUser?.accounts[accountIndex].currency = currency
            } catch {
                print("Error: \(error)")
            }
        }
    }*/
}

extension AccountExpenseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAccount.expenses.count
        //return filteredExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = currentAccount.expenses[indexPath.row]
        //let expense = filteredExpenses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = expense.name
        content.secondaryText = "Amount: \(expense.amount)"
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            let expenseToDelete = self.currentAccount.expenses[indexPath.row]
            self.currentAccount.expenses.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            UserFileManager.deleteExpenseForCurrentUser(expenseToDelete)
            self.tableView.reloadData()
            
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension AccountExpenseViewController: ExpenseViewControllerDelegate {
    func didAddExpense(_ expense: Expense) {
        currentAccount.expenses.append(expense)
        self.tableView.reloadData()
    }
}

extension AccountExpenseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterExpensesByCategory(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterExpensesByCategory("")
    }
    
    private func filterExpensesByCategory(_ searchText: String) {
        if searchText.isEmpty {
            filteredExpenses = currentAccount.expenses
        } else {
            filteredExpenses = currentAccount.expenses.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        self.tableView.reloadData()
    }
}
