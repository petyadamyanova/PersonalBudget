//
//  NameValidatorTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class NameValidatorTests: XCTestCase {
    let nameValidator = NameValidator()
    
    func testNameValidationIsValid() {
        let nameTest = "Petya"
        
        let nameValidationResult = nameValidator.isValid(nameTest)
        
        XCTAssertTrue(nameValidationResult, "Name \(nameTest) was not valid!")
    }
    
    func testUsernameValidationIsNotValid() {
        let nameTest = ""
        
        let nameValidationResult = nameValidator.isValid(nameTest)
        
        XCTAssertFalse(nameValidationResult, "Name \(nameTest) was valid!")
    }
}
