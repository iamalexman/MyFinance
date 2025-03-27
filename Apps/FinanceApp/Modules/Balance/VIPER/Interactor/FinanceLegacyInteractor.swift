//
//  FinanceLegacyInteractor.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import Network
import FinanceContracts

@MainActor protocol FinanceLegacyInteractorProtocol: AnyObject {
    
    var entity: FinanceLegacyEntity { get set }
    
    func fetchData(_ selectedDay: Int) async throws
}

@MainActor
final class FinanceLegacyInteractor {
    
    let requestService: FinanceRequestServiceProtocol
    
    var entity = FinanceLegacyEntity()
    
    init(requestService: FinanceRequestServiceProtocol) {
        self.requestService = requestService
    }
}

extension FinanceLegacyInteractor: FinanceLegacyInteractorProtocol {
    
    func fetchData(_ selectedDay: Int) async throws {

        let result = await requestService.fetchTransactions(for: selectedDay)
        
        switch result {
        case .success(let model):
            entity.transactions = model.transactions.compactMap { transaction in
                LegacyTransaction(
                    type: transaction?.type ?? "",
                    title: transaction?.name ?? "",
                    amount: transaction?.amount ?? 0,
                    timeStamp: transaction?.timeStamp ?? ""
                )
            }
        case .failure(let error):
            print(error.localizedDescription)
            throw error
        }
    }
}
