//
//  PasswordValidator.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 28.08.23.
//

import Foundation

class PasswordValidator {
    func isValid(_ password: String) -> Bool {
        password.count >= 8
    }
}
