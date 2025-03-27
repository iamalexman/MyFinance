//
//  FinanceEntity.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import Foundation

struct FinanceEntity {
    
    private let bonusAmount = 5
    
    var transactions: [Transaction]?
    
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
    
    var sortedTransactions: [Transaction] {
        transactions?.sorted { $0.timeStamp < $1.timeStamp } ?? []
    }
    
    private var totalAmount: Int {
        transactions?.reduce(0, { $0 + $1.amount }) ?? 0
    }
    
    private var expenses: [Transaction] {
        transactions?.filter { $0.amount < 0 } ?? []
    }
}

struct Transaction: Identifiable, Equatable {
    
    let id: UUID = UUID()
    let type: String
    let title: String
    let amount: Int
    let timeStamp: String
}
