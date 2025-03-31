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
    
    func test_getTransactions_whenDayIs1_returnsNil() async {
        
        // Given
        let invalidDay = 1
        
        // When
        let transactions = await server.getTransactions(for: invalidDay)
        
        // Then
        XCTAssertNil(transactions, "For day \(invalidDay) should return nil")
    }
    
    func test_getTransactions_whenDayIs6_returnsEmptyModel() async {
        
        // Given
        let dayWithEmptyData = 6
        
        // When
        let transactions = await server.getTransactions(for: dayWithEmptyData)
        
        // Then
        XCTAssertNotNil(transactions, "For day \(dayWithEmptyData) should return not nil")
        XCTAssertTrue(
            transactions?.transactions.isEmpty ?? false,
            "Transactions array for day \(dayWithEmptyData) should be empty"
        )
    }
}
