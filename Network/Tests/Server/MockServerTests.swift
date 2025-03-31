//
//  MockServerTests.swift
//  Network
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import XCTest
@testable import Network
import FinanceContracts

final class MockServerTests: XCTestCase {
    
    private var server: MockServer!
    
    override func setUp() {
        super.setUp()
        server = MockServer.shared
    }
    
    func test_getTransactions_whenDayIsValid_returnsData() async {
        
        // Given
        let validDay = 2
        
        // When
        let transactions = await server.getTransactions(for: validDay)
        
        // Then
        XCTAssertNotNil(transactions)
    }
    
    func test_getTransactions_whenDayIsInvalid_returnsNil() async {
        
        // Given
        let invalidDay = 1
        
        // When
        let transactions = await server.getTransactions(for: invalidDay)
        
        // Then
        XCTAssertNil(transactions)
    }
    
    func test_getTransactions_whenDayIs6_returnsEmptyModel() async {
        
        // Given
        let dayWithEmptyData = 6
        
        // When
        let transactions = await server.getTransactions(for: dayWithEmptyData)
        
        // Then
        XCTAssertNotNil(transactions)
        XCTAssertTrue(transactions?.transactions.isEmpty ?? false)
    }
}
