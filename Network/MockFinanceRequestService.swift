//
//  RequestBuilder.swift
//  Network
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import FinanceContracts

protocol FinanceRequestServiceProtocol {
    
    func fetchTransactions(for day: Int) async -> Result<FinanceModel, Error>
}

public final class MockFinanceRequestService: FinanceRequestServiceProtocol {
    
    enum FinanceError: Error {
        case serverError
    }
    
    let server = MockServer()
    
    public init() { }
    
    public func fetchTransactions(for day: Int) async -> Result<FinanceModel, Error> {
        
        let data = await MockServer.shared.getTransactions(for: day)
        
        if let data {
            return Result.success(data)
        }
        
        return Result.failure(FinanceError.serverError)
    }
}
