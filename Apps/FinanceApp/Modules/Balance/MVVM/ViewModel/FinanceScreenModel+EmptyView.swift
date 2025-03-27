//
//  FinanceScreenModel+EmptyView.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import SwiftUIComponents

extension FinanceScreenModel {
    
    var failureModel: FinanceEmptyView.Model? {
        
        guard !isLoading,
              hasError else {
            return nil
        }
        
        let model = FinanceEmptyView.Model(
            title: "Something went wrong",
            imageName: "exclamationmark.triangle",
            imageColor: .red.opacity(0.8),
            buttonTitle: "Retry",
            buttonAction: { [weak self] in
                self?.loadData()
            }
        )
        
        return model
    }
    
    var emptyModel: FinanceEmptyView.Model? {
        
        guard !isLoading,
              !hasError,
              entity.transactions?.isEmpty ?? true else {
            return nil
        }
        
        let model = FinanceEmptyView.Model(
            title: "There's no data",
            imageName: "magnifyingglass"
        )
        
        return model
    }
}
