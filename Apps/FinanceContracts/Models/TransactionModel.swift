//
//  TransactionModel.swift
//  FinanceContracts
//
//  Created by Alex Kuznetcov on 3/30/25.
//

public struct TransactionModel {
    
    public let id: UUID = UUID()
    public let image: String
    public let type: String
    public let name: String
    public let amount: Int?
    public let timeStamp: String?
    
    public init(
        image: String,
        type: String,
        name: String,
        amount: Int?,
        timeStamp: String?
    ) {
        self.image = image
        self.type = type
        self.name = name
        self.amount = amount
        self.timeStamp = timeStamp
    }
}
