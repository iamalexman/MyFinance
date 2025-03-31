//
//  MockServer.swift
//  Network
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import FinanceContracts

final class MockServer {
    
    static let shared = MockServer()
    
    private var allTransactions: [Int: FinanceModel] = [:]
    
    init() {
        generateAllTransactions()
    }
    
    private let stubTransactions: [StubTransaction] = [
        StubTransaction(image: "🥕", name: "Vegetables", type: "Expenses"),
        StubTransaction(image: "🍉", name: "Fruits", type: "Expenses"),
        StubTransaction(image: "📈", name: "Stocks", type: "Income"),
        StubTransaction(image: "📝", name: "Article", type: "Income"),
        StubTransaction(image: "🎮", name: "Games", type: "Expenses"),
        StubTransaction(image: "💸", name: "Transfer", type: "Income"),
        StubTransaction(image: "🌸", name: "Flowers", type: "Expenses"),
        StubTransaction(image: "🚕", name: "Taxi", type: "Expenses"),
        StubTransaction(image: "📉", name: "Stocks", type: "Expenses"),
        StubTransaction(image: "🎁", name: "Present", type: "Expenses"),
        StubTransaction(image: "💵", name: "Salary", type: "Income")
    ]
    
    private func makeAmount(_ type: String) -> Int {
        return switch type {
        case "Expenses": (-5000...0).randomElement() ?? 0
        default: (0...10000).randomElement() ?? 0
        }
    }
    
    private func makeRandomTransactionModel() -> TransactionModel? {
        stubTransactions.randomElement().map { transaction in
            TransactionModel(
                id: UUID().uuidString,
                image: transaction.type,
                type: transaction.image,
                name: transaction.name,
                amount: makeAmount(transaction.type),
                timeStamp: "\((0...12).randomElement() ?? 0):\((10...60).randomElement() ?? 0)"
            )
        }
    }
    
    private func makeSortedTransactions() -> [TransactionModel?] {
        (0...10).map { _ in makeRandomTransactionModel() }
    }
    
    private func generateAllTransactions() {
        for day in 0...6 {
            allTransactions[day] = FinanceModel(transactions: makeSortedTransactions())
        }
        // error check
        allTransactions[1] = nil
        // empty state check
        allTransactions[6] = FinanceModel(transactions: [])
    }
    
    func getTransactions(for day: Int) async -> FinanceModel? {
        try? await Task.sleep(nanoseconds: 2_500_000_000)
        return allTransactions[day]
    }
}

private struct StubTransaction {
    
    let image: String
    let name: String
    let type: String
}
