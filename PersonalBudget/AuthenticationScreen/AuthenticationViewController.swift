//
//  AuthenticationViewController.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import UIKit

class AuthenticationViewController: UIViewController {

    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginButton()
        setupWelcomeLabel()
    }
    
    private func setupLoginButton() {
        let loginAction = UIAction(title: "Login", handler: didTapLogin)
        navigationItem.leftBarButtonItem = UIBarButtonItem(primaryAction: loginAction)
    }
    
    private func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        view.addConstraints([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        welcomeLabel.text = "Wellcome!"
    }
    
    private func didTapLogin(_ action: UIAction) {
        let logInViewController = LogInViewController()
        logInViewController.delegate = self
        let navController = UINavigationController(rootViewController: logInViewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true)
    }
}

extension AuthenticationViewController: LogInViewControllerDelegate {
    func didLogin(_ user: String) {
        welcomeLabel.text = "Wellcome!"
   }
}
