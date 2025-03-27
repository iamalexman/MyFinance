//
//  FinanceLegacyPresenter+EmptyView.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

//import UIKit
import UIKitComponents

extension FinanceLegacyPresenter {
    
    func updateEmptyView(with model: FinanceLegacyEmptyView.Model) {
        view?.updateEmptyView(model)
    }
    
    var failureModel: FinanceLegacyEmptyView.Model {
        FinanceLegacyEmptyView.Model(
            title: "Something went wrong",
            imageName: "exclamationmark.triangle",
            imageColor: .red.withAlphaComponent(0.6),
            buttonTitle: "Retry",
            buttonAction: { [weak self] in
                self?.loadData()
            }
        )
    }

    var emptyModel: FinanceLegacyEmptyView.Model {
        FinanceLegacyEmptyView.Model(
            title: "There's no data",
            imageName: "magnifyingglass",
            imageColor: .systemGray4
        )
    }
}
