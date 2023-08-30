//
//  ExpenseViewControllerTests.swift
//  PersonalBudgetTests
//
//  Created by Petia Damyanova on 28.08.23.
//

import XCTest
@testable import PersonalBudget


final class ExpenseViewControllerTests: XCTestCase {
    var viewController: ExpenseViewController!
    var mockExpenseDelegate: MockExpenseViewControllerDelegate!

    override func setUpWithError() throws {
        viewController = ExpenseViewController()
        viewController.loadViewIfNeeded()

        mockExpenseDelegate = MockExpenseViewControllerDelegate()
        viewController.delegate = mockExpenseDelegate
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockExpenseDelegate = nil
    }

    func testDidAddExpenseCallsDelegate() {
        let testExpense = Expense(date: "2023-08-28", name: "Test Expense", amount: 50.0, category: "Test Category")

        mockExpenseDelegate.didAddExpense(testExpense)

        XCTAssertTrue(mockExpenseDelegate.didAddExpenseCalled)
        XCTAssertEqual(mockExpenseDelegate.addedExpense?.name, "Test Expense")
    }
}

class MockExpenseViewControllerDelegate: ExpenseViewControllerDelegate {
    var didAddExpenseCalled = false
    var addedExpense: Expense?

    func didAddExpense(_ expense: Expense) {
        didAddExpenseCalled = true
        addedExpense = expense
    }
}

