//
//  AppCardViewUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class AppCardViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAppCardViewExists() throws {
        // 检查 AppCardView 是否存在
        let card = app.otherElements["AppCardView"]
        XCTAssertTrue(card.exists, "AppCardView 应该存在于主界面")
    }
}
