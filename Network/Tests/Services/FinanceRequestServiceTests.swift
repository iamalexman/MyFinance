//
//  FinanceRequestServiceTests.swift
//  NetworkTests
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import XCTest
@testable import Network
import FinanceContracts

final class FinanceRequestServiceTests: XCTestCase {
    
    private var requestService: MockFinanceRequestService!
    
    override func setUp() {
        super.setUp()
        requestService = MockFinanceRequestService()
    }
    
    func test_fetchTransactions_whenDayIsValid_returnsSuccess() async {
        
        // Given
        let validDay = 0
        
        // When
        let result = await requestService.fetchTransactions(for: validDay)
        
        // Then
        switch result {
        case .success(let model):
            XCTAssertFalse(model.transactions.isEmpty)
        case .failure:
            XCTFail()
        }
    }
    
    func test_fetchTransactions_whenDayIs1_returnsServerError() async {
        
        // Given
        let invalidDay = 1
        
        // When
        let result = await requestService.fetchTransactions(for: invalidDay)
        
        // Then
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(
                error as? FinanceError,
                .serverError
            )
        }
    }
    
    func test_fetchTransactions_whenDayIs6_returnsEmptyModel() async {
        
        // Given
        let dayWithEmptyData = 6
        
        // When
        let result = await requestService.fetchTransactions(for: dayWithEmptyData)
        
        // Then
        switch result {
        case .success(let model):
            XCTAssertTrue(model.transactions.isEmpty)
        case .failure:
            XCTFail()
        }
    }
}
