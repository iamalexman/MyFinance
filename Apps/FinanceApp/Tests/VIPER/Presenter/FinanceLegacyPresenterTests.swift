//
//  FinanceLegacyPresenterTests.swift
//  FinanceAppTests
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import XCTest
@testable import FinanceApp
import UIKitComponents

@MainActor
final class FinanceLegacyPresenterTests: XCTestCase {
    
    var presenter: FinanceLegacyPresenter!
    var view: MockFinanceLegacyView!
    var interactor: MockFinanceLegacyInteractor!
    var router: MockFinanceLegacyRouter!
    
    override func setUp() {
        super.setUp()
        view = MockFinanceLegacyView()
        interactor = MockFinanceLegacyInteractor()
        router = MockFinanceLegacyRouter()
        presenter = FinanceLegacyPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
    }

    func test_viewDidLoad_callsInitialSetup() {
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(view.updateSegmentsCalled)
        XCTAssertTrue(interactor.entity.weekDays.count > 0)
    }
    
    func test_loadData_whenCalled_resetsStateAndStartsLoading() {
        
        // When
        presenter.loadData()
        
        // Then
        XCTAssertTrue(presenter.isLoading)
        XCTAssertFalse(presenter.hasError)
        XCTAssertNil(presenter.balance.transactions)
    }
    
    func test_asyncFetchData_whenSuccess_updatesViewCorrectly() async {
        
        // Given
        interactor.entity.transactions = [
            LegacyTransaction(
                type: "test",
                title: "test",
                amount: 100,
                timeStamp: "00:00"
            )
        ]
        
        // When
        presenter.asyncFetchData()
        await Task.yield()
        
        // Then
        XCTAssertFalse(presenter.isLoading)
        XCTAssertFalse(presenter.hasError)
        XCTAssertEqual(view.updateTransactionsCallCount, 1)
    }
    
    func test_asyncFetchData_whenFailure_setsErrorState() async {
        
        // Given
        interactor.shouldThrowError = true
        
        // When
        presenter.asyncFetchData()
        await Task.yield()
        
        // Then
        XCTAssertTrue(presenter.hasError)
        XCTAssertEqual(view.emptyViewModel?.imageName, "exclamationmark.triangle")
    }
    
    func test_asyncFetchData_whenSuccess_setsEmptyState() async {
        
        // Given
        interactor.entity.transactions = []
        
        // When
        presenter.asyncFetchData()
        await Task.yield()
        
        // Then
        XCTAssertFalse(presenter.hasError)
        XCTAssertEqual(view.emptyViewModel?.imageName, "magnifyingglass")
    }

    func test_didSelectDay_whenNewIndexSelected_updatesDayAndReloads() {
        
        // Given
        let initialDay = presenter.selectedDay
        let newDay = 2
        
        // When
        presenter.didSelectDay(index: newDay)
        
        // Then
        XCTAssertNotEqual(presenter.selectedDay, initialDay)
        XCTAssertEqual(presenter.selectedDayName, "WEDNESDAY")
        XCTAssertTrue(view.updateSegmentsCalled)
    }
    
    func test_didPullToRefresh_resetsDataAndReloads() async {
        
        // Given
        interactor.entity.transactions = [
            LegacyTransaction(
                type: "test",
                title: "test",
                amount: 100,
                timeStamp: "00:00"
            )
        ]
        
        // When
        presenter.didPullToRefresh()
        
        // Then
        XCTAssertTrue(presenter.isLoading)
        XCTAssertNil(interactor.entity.transactions)
        
        await waitForLoadingCompletion()
        
        XCTAssertFalse(presenter.isLoading)
    }
    
    func test_updateBalance_whenHasError_showsErrorView() {
        
        // Given
        presenter.hasError = true
        presenter.isLoading = false
        view.reset()
        
        // When
        presenter.updateBalance()
        
        // Then
        XCTAssertEqual(view.emptyViewModel?.buttonTitle, "Retry")
    }
    
    private func waitForLoadingCompletion() async {
        
        let timeout: TimeInterval = 2.0
        let startTime = Date()
        
        while presenter.isLoading && Date().timeIntervalSince(startTime) < timeout {
            await Task.yield()
        }
    }
}

final class MockFinanceLegacyView: FinanceLegacyViewInputProtocol {
    
    var updateSegmentsCalled = false
    var updateTransactionsCallCount = 0
    var emptyViewModel: FinanceLegacyEmptyView.Model?
    
    func updateBalance() { }
    
    func updateSegments(_ segments: [String]) {
        updateSegmentsCalled = true
    }
    
    func updateTransactions() {
        updateTransactionsCallCount += 1
    }
    
    func updateEmptyView(_ model: FinanceLegacyEmptyView.Model) {
        emptyViewModel = model
    }
    
    func reset() {
        emptyViewModel = nil
    }
}

final class MockFinanceLegacyInteractor: FinanceLegacyInteractorProtocol {
    
    var shouldThrowError = false
    var entity = FinanceLegacyEntity()
    
    func fetchData(_ selectedDay: Int) async throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: 0)
        }
    }
}

final class MockFinanceLegacyRouter: FinanceLegacyRouterInputProtocol { }
