//
//  FinanceLegacyBuilderProtocol.swift
//  FinanceContracts
//
//  Created by Alex Kuznetcov on 3/29/25.
//

public protocol FinanceRequestServiceProtocol {
    
    func fetchTransactions(for day: Int) async -> Result<FinanceModel, Error>
}
