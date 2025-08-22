//
//  ProfilePageUITests.swift
//  CrayonUITests
//
//  Created by Copilot on 2025/8/22.
//

import XCTest

final class ProfilePageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testProfilePageExists() throws {
        // 检查 Profile 页面是否存在
        let profilePage = app.otherElements["ProfilePage"]
        XCTAssertTrue(profilePage.exists, "Profile 页面应该存在于主界面")
    }

    func testSwitchToProfilePage() throws {
        // 假设底部导航栏有按钮 accessibilityIdentifier 为 "Tab_Profile"
        let tabButton = app.buttons["Tab_Profile"]
        if tabButton.exists {
            tabButton.tap()
        }
        let profilePage = app.otherElements["ProfilePage"]
        XCTAssertTrue(profilePage.waitForExistence(timeout: 2), "切换到 Profile 页面后应显示 ProfilePage 元素")
    }

    func testProfilePageMainElements() throws {
        // 检查页面主要元素（如头像、用户名、登出按钮等）
        let avatar = app.images["ProfileAvatar"]
        XCTAssertTrue(avatar.exists, "Profile 页面应有头像")
        let logoutButton = app.buttons["LogoutButton"]
        XCTAssertTrue(logoutButton.exists, "Profile 页面应有登出按钮")
    }
}
