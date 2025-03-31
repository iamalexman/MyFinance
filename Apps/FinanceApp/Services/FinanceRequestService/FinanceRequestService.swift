//
//  FinanceRequestService.swift
//  MyFinance
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import Network
import FinanceContracts

public final class FinanceRequestService {
    
    private let requestService = MockFinanceRequestService()
    
    public init() { }
    
}

extension FinanceRequestService: FinanceRequestServiceProtocol {
    
    public func fetchTransactions(for day: Int) async throws -> Result<FinanceModel, Error> {
        await requestService.fetchTransactions(for: day)
    }
}
