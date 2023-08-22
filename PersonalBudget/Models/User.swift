//
//  User.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String
    var username: String
    var password: String
    var accounts: [Account]
}

struct Account: Codable {
    var accountName: String
    var accountType: String
    var openingBalance: Int
}

struct Expense: Codable {
    var date: Date
    var name: String
    var amount: Double
    var category: String
}
