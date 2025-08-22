//
//  CustomBottomNavBarUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class CustomBottomNavBarUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testCustomBottomNavBarExists() throws {
        // 检查底部导航栏是否存在
        let tabBar = app.otherElements["CustomBottomNavBar"]
        XCTAssertTrue(tabBar.exists, "CustomBottomNavBar 应该存在于主界面")
    }
}
