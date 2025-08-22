//
//  EmptyAppsViewUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//
import XCTest
final class EmptyAppsViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testEmptyAppsViewExists() throws {
        // 检查 EmptyAppsView 是否存在
        let emptyView = app.otherElements["EmptyAppsView"]
        XCTAssertTrue(emptyView.exists, "EmptyAppsView 应该存在于主界面")
    }
}
