//
//  FinanceModel.swift
//  FinanceContracts
//
//  Created by Alex Kuznetcov on 3/30/25.
//

public struct FinanceModel {
    
    public let transactions: [TransactionModel?]
    
    public init(transactions: [TransactionModel?]) {
        self.transactions = transactions
    }
}
