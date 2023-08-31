//
//  EmailValidatorTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class EmailValidatorTests: XCTestCase {
    let emailValidator = EmailValidator()
    
    func testEmailValidationIsValid() {
        let emailTest = "test@example.com"
        
        let emailValidationResult = emailValidator.isValid(emailTest)
        
        XCTAssertTrue(emailValidationResult, "Email \(emailTest) was not valid!")
    }
    
    func testEmailValidationIsNotValid() {
        let emailTest = "invalid_email"
        
        let emailValidationResult = emailValidator.isValid(emailTest)
        
        XCTAssertFalse(emailValidationResult, "Email \(emailTest) was valid!")
    }
}
