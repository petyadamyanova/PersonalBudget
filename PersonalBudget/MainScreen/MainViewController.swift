//
//  ViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

final class MainViewController: UIViewController {
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginButton()
        setupAccountButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = UsersManager.shared.getCurrentUser() else {
            return
        }
        currentUser = user
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
}
