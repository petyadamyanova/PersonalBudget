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
    //var currency: Currency
}

struct Account: Codable {
    var accountName: String
    var accountType: String
    var openingBalance: Int
    var expenses: [Expense]
}

struct Expense: Codable {
    var date: String
    var name: String
    var amount: Double
    var category: String
}

enum Currency: String, CaseIterable, Codable {
    case EUR
    case USD
    case CAD
    case JPY
    case BGN
    case RUB
    case GBP
}


