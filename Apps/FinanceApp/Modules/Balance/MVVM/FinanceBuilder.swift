//
//  FinanceBuilder.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit
import SwiftUI
import FinanceContracts

public final class FinanceBuilder {
    
    private let requestService: FinanceRequestServiceProtocol
    
    public init(requestService: FinanceRequestServiceProtocol) {
        self.requestService = requestService
    }
}

@MainActor extension FinanceBuilder: FinanceBuilderProtocol {
    
    public func build() -> UIViewController {
        
        let router = FinanceRouter()
        
        let viewModel = FinanceScreenModel(
            router: router,
            requestService: requestService
        )
        
        let view = FinanceScreen(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        
        router.viewController = viewController
        
        return viewController
    }
}
