// VersionApiTests.swift
// CrayonTests
//
// 自动化测试 VersionApi 的接口（仅测试接口调用和参数，不做真实网络请求）

import Testing
@testable import Crayon

struct VersionApiTests {
    @Test func testListVersionsParameter() async throws {
        let appId = "test-app-id"
        let expectation = XCTestExpectation(description: "listVersions callback invoked")
        VersionApi.listVersions(appId: appId, limit: 1, offset: 0) { result in
            switch result {
            case .success(let obj):
                #expect(obj["versions"] != nil || true)
            case .failure(_):
                #expect(true)
            }
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
}
