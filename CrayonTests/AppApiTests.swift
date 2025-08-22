// AppApiTests.swift
// CrayonTests
//
// 自动化测试 AppApi 的基本接口（仅测试接口调用和 mock 数据，不做真实网络请求）

import Testing
@testable import Crayon

struct AppApiTests {
    @Test func testGetAppsIUseMock() async throws {
        // 由于 AppApi 真实接口依赖网络，这里仅测试 AppsViewModel 的 mock 数据分支
        let viewModel = AppsViewModel()
        viewModel.useMockData = true
        viewModel.showBookmarkedOnly = false
        let token = "mock-token"
        let expectation = XCTestExpectation(description: "fetchRecentApps loads mock data")
        viewModel.fetchRecentApps(token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            #expect(viewModel.recentApps.count == MockData.sampleApps.count)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
}
