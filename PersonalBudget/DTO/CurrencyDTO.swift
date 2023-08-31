//
//  CurrencyDTO.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 31.08.23.
//

import Foundation

struct CurrencyDTO: Codable {
    var timestamp: Date
    var rates: [String: Double]
}
