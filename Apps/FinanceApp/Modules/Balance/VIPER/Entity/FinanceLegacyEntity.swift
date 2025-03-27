//
//  FinanceLegacyEntity.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import Foundation

struct FinanceLegacyEntity {
    
    private let bonusAmount = 5
    var transactions: [LegacyTransaction]?
    
    let bonusImageName = "CoinIcon24"
    let balanceSectionTitle = "Balance"
    let transactionsSectionTitle = "Transactions"
    let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var bonusTotal: Int {
        expenses.reduce(0, { $0 - $1.amount }) * bonusAmount / 100
    }
    
    var bonusTotalString: String {
        
        guard transactions != nil else {
            return "---"
        }
        
        return bonusTotal.formatted().description
    }
    
    var totalAmountString: String {
        
        guard transactions != nil else {
            return "---"
        }
        
        return totalAmount > 0
        ? "+ \(totalAmount.formatted())"
        : totalAmount.formatted().description
    }
    
    var sortedTransactions: [LegacyTransaction] {
        transactions?.sorted { $0.timeStamp < $1.timeStamp } ?? []
    }
    
    private var totalAmount: Int {
        transactions?.reduce(0, { $0 + $1.amount }) ?? 0
    }
    
    private var expenses: [LegacyTransaction] {
        transactions?.filter { $0.amount < 0 } ?? []
    }
}

struct LegacyTransaction: Identifiable, Equatable {
    
    let id: UUID = UUID()
    let type: String
    let title: String
    let amount: Int
    let timeStamp: String
}
