//
//  FinanceLegacyBuilder.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit
import FinanceContracts

public final class FinanceLegacyBuilder {
    
    private let requestService: FinanceRequestServiceProtocol
    
    public init(requestService: FinanceRequestServiceProtocol) {
        self.requestService = requestService
    }
}

@MainActor extension FinanceLegacyBuilder: FinanceBuilderProtocol {
    
    public func build() -> UIViewController {
        
        let view = FinanceLegacyViewController()
        let interactor = FinanceLegacyInteractor(requestService: requestService)
        let router = FinanceLegacyRouter()
        
        let presenter = FinanceLegacyPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        
        return view
    }
}
