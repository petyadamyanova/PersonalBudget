//
//  ViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

final class MainViewController: UIViewController {
    var currentUser: User?
    var tableView: UITableView!
    let cellIdentifier = "Account"
    var accounts: [Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginButton()
        setupAccountButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        
        if let user = UsersManager.shared.getCurrentUser() {
            currentUser = user
            
            if let accounts = currentUser?.accounts, !accounts.isEmpty {
                self.accounts = accounts
                tableView.reloadData()
            }
        }
    }
    
      private func configureTableView() {
          let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
                  
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
          //tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.indentifier)
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
    
    private func setupLoginButton() {
        let logoutAction = UIAction(title: "Logout", handler: didTapLogout)
        navigationItem.leftBarButtonItem = UIBarButtonItem(primaryAction: logoutAction)
    }
    
    private func setupAccountButton() {
        let accountAction = UIAction(title: "Account", handler: didTapAccount)
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: accountAction)
    }
    
    private func didTapLogout(_ action: UIAction) {
        currentUser = nil
        UsersManager.shared.removeCurrentUser()
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    private func didTapAccount(_ action: UIAction) {
        let accountViewController = AccountViewController()
        navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    func getUserData() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "userData") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            print("Error decoding user data: \(error)")
            return nil
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accounts = currentUser?.accounts else {
            return 0
        }
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = currentUser?.accounts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = account?.accountName
        content.secondaryText = "Balance: \(account?.openingBalance ?? 0)"
        cell.contentConfiguration = content
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        guard let userName = currentUser?.name as? String else { return nil }
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = "\(userName)'s bank accounts: "
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedAccount = currentUser?.accounts[indexPath.row] else {
            return
        }
        
        UsersManager.shared.setCurrentAccount(selectedAccount)
        
        let accountDetailViewController = AccountExpenseViewController()
        navigationController?.pushViewController(accountDetailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: AccountViewControllerDelegate {
    func didAddAccount(_ account: Account) {
        accounts.append(account)
        self.tableView.reloadData()
    }
}
