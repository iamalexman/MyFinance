//
//  FinanceScreenModel+Network.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

extension FinanceScreenModel {
    
    func loadData() {
        clearData()
        asyncFetchData()
    }
    
    func clearData() {
        hasError = false
        entity.transactions = nil
    }
    
    private func asyncFetchData() {
        
        task?.cancel()
        
        isLoading = true
        
        task = Task {
            
            let result = await requestService.fetchTransactions(for: selectedDay)
            
            switch result {
            case .success(let model):
                entity.transactions = model.transactions.compactMap { transaction in
                    Transaction(
                        type: transaction?.type ?? "",
                        title: transaction?.name ?? "",
                        amount: transaction?.amount ?? 0,
                        timeStamp: transaction?.timeStamp ?? ""
                    )
            }
            case .failure(let error):
                hasError = true
                entity.transactions = nil
                print(error.localizedDescription)
            }
            
            guard !Task.isCancelled else { return }
            isLoading = false
        }
    }
}
