//
//  PrimaryActionBtnUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class PrimaryActionBtnUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testPrimaryActionBtnExists() throws {
        // 检查主操作按钮是否存在
        let button = app.buttons["PrimaryActionBtn"]
        XCTAssertTrue(button.exists, "PrimaryActionBtn 应该存在于主界面")
    }
}
