//
//  FinanceScreenModelTests.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import XCTest
@testable import FinanceApp
import FinanceContracts

@MainActor
final class FinanceScreenModelTests: XCTestCase {
    
    var screenModel: FinanceScreenModel!
    var mockRequestService: MockFinanceRequestService!
    var mockRouter: MockFinanceRouter!
    
    override func setUp() {
        super.setUp()
        mockRequestService = MockFinanceRequestService()
        mockRouter = MockFinanceRouter()
        screenModel = FinanceScreenModel(
            router: mockRouter,
            requestService: mockRequestService
        )
    }

    func test_loadData_whenCalled_shouldResetStateAndStartLoading() {
        // Given
        screenModel.entity.transactions = [Transaction.stub()]
        screenModel.hasError = true
        
        // When
        screenModel.loadData()
        
        // Then
        XCTAssertTrue(screenModel.isLoading)
        XCTAssertFalse(screenModel.hasError)
        XCTAssertNil(screenModel.entity.transactions)
    }
    
    func test_asyncFetchData_whenSuccess_shouldUpdateTransactions() async {
        
        // Given
        let testData = [
            Transaction.stub(title: "Salary", amount: 1000),
            Transaction.stub(title: "Rent", amount: -500)
        ]
        
        mockRequestService.stubResult = .success(
            FinanceModel(
                transactions: testData.map {
                    TransactionModel(
                        image: "Image",
                        type: $0.type,
                        name: $0.title,
                        amount: $0.amount,
                        timeStamp: $0.timeStamp)
                }
            )
        )
        
        // When
        screenModel.loadData()
        await waitForLoadingCompletion()
        
        // Then
        XCTAssertFalse(screenModel.isLoading)
        XCTAssertEqual(screenModel.entity.transactions?.count, 2)
        XCTAssertEqual(screenModel.entity.transactions?.first?.title, "Salary")
    }
    
    func test_asyncFetchData_whenFailure_shouldSetErrorState() async {
        
        // Given
        mockRequestService.stubResult = .failure(MockError.serverError)
        
        // When
        screenModel.loadData()
        await waitForLoadingCompletion()
        
        // Then
        XCTAssertTrue(screenModel.hasError)
        XCTAssertNil(screenModel.entity.transactions)
    }
    
    // MARK: - Cancellation Tests
    
    func test_taskCancellation_whenReloading_shouldCancelPreviousRequest() async {
        
        // Given
        mockRequestService.delay = 0.1
        screenModel.loadData()
        
        // When
        screenModel.loadData() // Second call cancels first
        
        // Then
        await waitForLoadingCompletion()
        XCTAssertEqual(mockRequestService.cancellationCount, 1)
    }
    
    // MARK: - State Models Tests
    
    func test_failureModel_whenHasError_shouldReturnCorrectModel() {
        
        // Given
        screenModel.hasError = true
        screenModel.isLoading = false
        
        // When
        let model = screenModel.failureModel
        
        // Then
        XCTAssertEqual(model?.title, "Something went wrong")
        XCTAssertEqual(model?.imageName, "exclamationmark.triangle")
        XCTAssertNotNil(model?.buttonAction)
    }
    
    func test_emptyModel_whenNoData_shouldReturnCorrectModel() {
        
        // Given
        screenModel.entity.transactions = []
        screenModel.isLoading = false
        screenModel.hasError = false
        
        // When
        let model = screenModel.emptyModel
        
        // Then
        XCTAssertEqual(model?.title, "There's no data")
        XCTAssertEqual(model?.imageName, "magnifyingglass")
    }

    private func waitForLoadingCompletion() async {
        
        let timeout: TimeInterval = 2.0
        let startTime = Date()
        
        while screenModel.isLoading && Date().timeIntervalSince(startTime) < timeout {
            await Task.yield()
        }
    }
}

// MARK: - Mock Implementations
enum MockError: Error {
    case serverError
}

final class MockFinanceRequestService: FinanceRequestServiceProtocol {
    
    var stubResult: Result<FinanceModel, Error> = .success(FinanceModel(transactions: []))
    var delay: TimeInterval = 0
    var cancellationCount = 0
    
    func fetchTransactions(for day: Int) async -> Result<FinanceModel, Error> {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return stubResult
        } catch is CancellationError {
            cancellationCount += 1
            return .failure(MockError.serverError)
        } catch {
            return .failure(error)
        }
    }
}

final class MockFinanceRouter: FinanceRouterProtocol { }

extension Transaction {
    
    static func stub(title: String = "Test", amount: Int = 0) -> Transaction {
        Transaction(
            type: "General",
            title: title,
            amount: amount,
            timeStamp: "12:00"
        )
    }
}
