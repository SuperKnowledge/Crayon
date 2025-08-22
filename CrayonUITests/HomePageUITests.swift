//
//  HomePageUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class HomePageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testHomePageExists() throws {
        // 检查 Home 页面是否存在
        let homePage = app.otherElements["HomePage"]
        XCTAssertTrue(homePage.exists, "Home 页面应该存在于主界面")
    }

    func testSwitchToHomePage() throws {
        // 假设底部导航栏有按钮 accessibilityIdentifier 为 "Tab_Home"
        let tabButton = app.buttons["Tab_Home"]
        if tabButton.exists {
            tabButton.tap()
        }
        let homePage = app.otherElements["HomePage"]
        XCTAssertTrue(homePage.waitForExistence(timeout: 2), "切换到 Home 页面后应显示 HomePage 元素")
    }

    func testHomePageMainElements() throws {
        // 检查页面主要元素（如欢迎文本、快捷入口等）
        let welcomeText = app.staticTexts["WelcomeText"]
        XCTAssertTrue(welcomeText.exists, "Home 页面应有欢迎文本")
        let quickEntry = app.buttons["QuickEntryButton"]
        XCTAssertTrue(quickEntry.exists, "Home 页面应有快捷入口按钮")
    }
}
