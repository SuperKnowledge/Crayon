// ChatApiTests.swift
// CrayonTests
//
// 自动化测试 ChatAPI 的接口（仅测试接口调用和参数，不做真实网络请求）

import Testing
@testable import Crayon

struct ChatApiTests {
    @Test func testSendMessageParameter() async throws {
        // 这里只测试参数拼接和回调，不做真实网络请求
        let message = "hello"
        let appId = "test-app-id"
        let model = "gpt-4"
        let expectation = XCTestExpectation(description: "sendMessage callback invoked")
        ChatAPI.sendMessage(appId: appId, message: message, screenshotUrl: nil, model: model) { result in
            // 由于无网络，预期 result 为 failure
            switch result {
            case .success(_):
                #expect(false, "Should not succeed in unit test without server")
            case .failure(_):
                #expect(true)
            }
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
}
