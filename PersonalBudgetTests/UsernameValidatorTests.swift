//
//  UsernameValidatorTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class UsernameValidatorTests: XCTestCase {
    let usernameValidator = UsernameValidator()
    
    func testUsernameValidationIsValid() {
        let usernameTest = "Petya"
        
        let usernameValidationResult = usernameValidator.isValid(usernameTest)
        
        XCTAssertTrue(usernameValidationResult, "Username \(usernameTest) was not valid!")
    }
    
    func testUsernameValidationIsNotValid() {
        let usernameTest = "P"
        
        let usernameValidationResult = usernameValidator.isValid(usernameTest)
        
        XCTAssertFalse(usernameValidationResult, "Username \(usernameTest) was valid!")
    }
}
