//
//  PasswordValidatorTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class PasswordValidatorTests: XCTestCase {
    let passwordValidator = PasswordValidator()
    
    func testPasswordValidationIsValid() {
        let passwordTest = "11111111"
        
        let passwordValidationResult = passwordValidator.isValid(passwordTest)
        
        XCTAssertTrue(passwordValidationResult, "Password \(passwordTest) was not valid!")
    }
    
    func testPasswordValidationIsNotValid() {
        let passwordTest = "1111"
        
        let passwordValidationResult = passwordValidator.isValid(passwordTest)
        
        XCTAssertFalse(passwordValidationResult, "Password \(passwordTest) was valid!")
    }
    
}
