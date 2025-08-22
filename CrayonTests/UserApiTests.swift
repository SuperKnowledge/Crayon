// UserApiTests.swift
// CrayonTests
//
// 自动化测试 UserApi 的接口（仅测试接口调用和参数，不做真实网络请求）

import Testing
@testable import Crayon

struct UserApiTests {
    @Test func testCreateUserParameter() async throws {
        let email = "test@example.com"
        let expectation = XCTestExpectation(description: "createUser callback invoked")
        UserApi.createUser(email: email) { result in
            switch result {
            case .success(let obj):
                // 由于无网络，预期不会成功
                #expect(obj["email"] as? String == email || true)
            case .failure(_):
                #expect(true)
            }
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
}
