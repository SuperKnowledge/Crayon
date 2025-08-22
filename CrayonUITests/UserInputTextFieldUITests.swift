//
//  UserInputTextFieldUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class UserInputTextFieldUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testUserInputTextFieldExists() throws {
        // 检查 UserInputTextField 是否存在
        let textField = app.textFields["UserInputTextField"]
        XCTAssertTrue(textField.exists, "UserInputTextField 应该存在于主界面")
    }
}
