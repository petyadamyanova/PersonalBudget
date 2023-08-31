//
//  RegisterViewControllerTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget

final class RegisterViewControllerTests: XCTestCase {
    var viewController: RegisterViewController!

    override func setUpWithError() throws {
        viewController = RegisterViewController()
        viewController.loadViewIfNeeded()
        UserFileManager.saveUsersData([])
    }

    override func tearDownWithError() throws {
        viewController = nil
    }

    func testRegistrationWithValidData() {
        viewController.nameField.textField.text = "John Doe"
        viewController.emailField.textField.text = "john@example.com"
        viewController.usernameField.textField.text = "johndoe"
        viewController.passwordField.textField.text = "password"
        viewController.secondPasswordField.textField.text = "password"
        
        let submitAction_ = UIAction(title: "Submit") { _ in }
        
        viewController.didtapRegisterButton(submitAction_)

        let users = UserFileManager.loadUsersData()
        XCTAssertEqual(users?.count, 1)
        XCTAssertEqual(users?.first?.name, "John Doe")
        XCTAssertEqual(users?.first?.username, "johndoe")
        XCTAssertEqual(users?.first?.password, "password")
    }
    
    func testIfRegistrationFailsWithWrongData() {
        viewController.nameField.textField.text = "John Doe"
        viewController.emailField.textField.text = "john@example.com"
        viewController.usernameField.textField.text = "johndoe"
        viewController.passwordField.textField.text = "password"
        viewController.secondPasswordField.textField.text = "password"
        
        let submitAction_ = UIAction(title: "Submit") { _ in }
        
        viewController.didtapRegisterButton(submitAction_)

        let users = UserFileManager.loadUsersData()
        XCTAssertEqual(users?.count, 1)
        XCTAssertNotEqual(users?.first?.name, "J")
    }
}
