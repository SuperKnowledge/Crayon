//
//  CrayonTests.swift
//  CrayonTests
//
//  Created by leetao on 2025/8/3.
//

import Testing
@testable import Crayon

import Foundation
import Combine

struct CrayonTests {

    @Test func testAppsViewModelMockData() async throws {
        let viewModel = AppsViewModel()
        viewModel.useMockData = true
        viewModel.showBookmarkedOnly = false
        let token = "mock-token"

        // Test fetchRecentApps loads all mock apps
        let expectation1 = XCTestExpectation(description: "fetchRecentApps loads all mock apps")
        viewModel.fetchRecentApps(token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            #expect(viewModel.recentApps.count == MockData.sampleApps.count)
            expectation1.fulfill()
        }
        await fulfillment(of: [expectation1], timeout: 2)

        // Test toggleBookmarkedFilter switches to bookmarked only
        let expectation2 = XCTestExpectation(description: "toggleBookmarkedFilter loads only bookmarked apps")
        viewModel.toggleBookmarkedFilter(token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            #expect(viewModel.recentApps == MockData.bookmarkedApps)
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation2], timeout: 1)

        // Test toggleBookmark changes bookmark status in mock data
        if let firstApp = viewModel.recentApps.first {
            let expectation3 = XCTestExpectation(description: "toggleBookmark updates bookmark status")
            let originalStatus = firstApp.isBookmarked
            viewModel.toggleBookmark(for: firstApp, token: token)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let updatedApp = viewModel.recentApps.first { $0.publicationId == firstApp.publicationId }
                #expect(updatedApp?.isBookmarked == !originalStatus)
                expectation3.fulfill()
            }
            await fulfillment(of: [expectation3], timeout: 1)
        }

        // Test removeApp removes app from recentApps
        if let appToRemove = viewModel.recentApps.first {
            let expectation4 = XCTestExpectation(description: "removeApp removes app from recentApps")
            let id = appToRemove.publicationId
            viewModel.removeApp(publicationId: id, token: token)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                #expect(!viewModel.recentApps.contains(where: { $0.publicationId == id }))
                expectation4.fulfill()
            }
            await fulfillment(of: [expectation4], timeout: 1)
        }
    }

}
