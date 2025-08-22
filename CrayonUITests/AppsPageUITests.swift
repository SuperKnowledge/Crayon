//
//  AppsPageUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class AppsPageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAppsPageExists() throws {
        // 检查 Apps 页面是否存在
        let appsPage = app.otherElements["AppsPage"]
        XCTAssertTrue(appsPage.exists, "Apps 页面应该存在于主界面")
    }

    func testSwitchToAppsPage() throws {
        // 假设底部导航栏有按钮 accessibilityIdentifier 为 "Tab_Apps"
        let tabButton = app.buttons["Tab_Apps"]
        if tabButton.exists {
            tabButton.tap()
        }
        let appsPage = app.otherElements["AppsPage"]
        XCTAssertTrue(appsPage.waitForExistence(timeout: 2), "切换到 Apps 页面后应显示 AppsPage 元素")
    }

    func testAppsPageMainElements() throws {
        // 检查页面主要元素（如列表、添加按钮等）
        let addButton = app.buttons["AddAppButton"]
        XCTAssertTrue(addButton.exists, "Apps 页面应有添加按钮")
        let appsList = app.tables["AppsList"]
        XCTAssertTrue(appsList.exists, "Apps 页面应有应用列表")
    }
}
