//
//  UsernameValidator.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 28.08.23.
//

import Foundation

class UsernameValidator {
    func isValid(_ username: String) -> Bool {
        username.count >= 3
    }
}
