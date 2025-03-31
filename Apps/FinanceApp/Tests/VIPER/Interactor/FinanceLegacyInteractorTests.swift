//
//  FinanceLegacyInteractorTests.swift
//  Tests
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import XCTest
@testable import FinanceApp
import FinanceContracts
import Network

@MainActor
final class FinanceLegacyInteractorTests: XCTestCase {
    
    private var interactor: FinanceLegacyInteractor!
    private var requestService: MockFinanceRequestServiceTests!
    
    override func setUp() {
        super.setUp()
        requestService = MockFinanceRequestServiceTests()
        interactor = FinanceLegacyInteractor(requestService: requestService)
    }
    
    func test_fetchData_whenServiceReturnsSuccess_updatesTransactions() async {
        
        // Given
        let testDay = 0
        let expectedTransactions = [
            TransactionModel(
                image: "test",
                type: "Income",
                name: "Salary",
                amount: 1000,
                timeStamp: "10:00"
            )
        ]
        
        requestService.stubResponse = .success(FinanceModel(transactions: expectedTransactions))
        
        // When
        do {
            try await interactor.fetchData(testDay)
        } catch {
            XCTFail()
        }
        
        // Then
        XCTAssertEqual(interactor.entity.transactions?.count, 1)
        XCTAssertEqual(interactor.entity.transactions?.first?.title, "Salary")
        XCTAssertEqual(interactor.entity.transactions?.first?.amount, 1000)
    }
    
    func test_fetchData_whenServiceReturnsError_propagatesError() async {
        
        // Given
        let testDay = 1
        requestService.stubResponse = .failure(FinanceError.serverError)
        
        // When & Then
        await XCTAssertThrowsError(try await interactor.fetchData(testDay)) { error in
            XCTAssertEqual(error as? FinanceError, .serverError)
        }
    }
    
    func test_entityBonusTotal_whenHasExpenses_calculatesCorrectValue() {
        
        // Given
        interactor.entity.transactions = [
            LegacyTransaction(type: "", title: "", amount: -100, timeStamp: ""),
            LegacyTransaction(type: "", title: "", amount: -200, timeStamp: "")
        ]
        
        // Then
        XCTAssertEqual(interactor.entity.bonusTotal, 15) // (100 + 200) * 5 / 100
    }
    
    func test_totalAmountString_whenNoTransactions_returnsPlaceholder() {
        
        // Given
        interactor.entity.transactions = nil
        
        // Then
        XCTAssertEqual(interactor.entity.totalAmountString, "---")
    }
    
    func test_sortedTransactions_whenMultipleExist_ordersByTimestamp() {
        
        // Given
        interactor.entity.transactions = [
            LegacyTransaction(type: "", title: "", amount: 0, timeStamp: "12:00"),
            LegacyTransaction(type: "", title: "", amount: 0, timeStamp: "09:00")
        ]
        
        // Then
        XCTAssertEqual(interactor.entity.sortedTransactions.first?.timeStamp, "09:00")
    }
    
    func XCTAssertThrowsError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail("No error thrown", file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}

final class MockFinanceRequestServiceTests: FinanceRequestServiceProtocol {
    
    public var stubResponse: Result<FinanceModel, Error> = .failure(FinanceError.serverError)
    
    public func fetchTransactions(for day: Int) async -> Result<FinanceModel, Error> {
        stubResponse
    }
}
