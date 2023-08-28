//
//  LogInViewControllerTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class LogInViewControllerTests: XCTestCase {

    func testLoginWithValidCredentials() {
        // Set up the view controller with a mock delegate and user data
        let mockDelegate = MockLogInViewControllerDelegate()
        var viewController = LogInViewController()
    
        viewController.delegate = mockDelegate
    
        let user = User(name:"Prtya", email: "aa@aa.aa", username: "testUser", password: "password", accounts: [])
    
        UserFileManager.saveUsersData([user])
        
        viewController.usernameField.textField.text = "testUser"
        viewController.passwordField.textField.text = "password"
    
        let submitAction = UIAction(title: "Submit") { _ in }
        
        viewController.didtapSubmitButton(submitAction)
        
        XCTAssertTrue(mockDelegate.didLoginCalled)
        }
}

class MockLogInViewControllerDelegate: LogInViewControllerDelegate {
    var didLoginCalled = false
    
    func didLogin(_ username: String) {
        didLoginCalled = true
    }
}
