//
//  AccountExpenseViewController.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 22.08.23.
//

import UIKit

class AccountExpenseViewController: UIViewController {
    
    var account: Account
        
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }
}
