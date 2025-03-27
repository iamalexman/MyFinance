//
//  FinanceScreenModel.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import Utilities
import FinanceContracts

@MainActor final class FinanceScreenModel: FinanceScreenModelProtocol {
    
    let router: FinanceRouterProtocol
    let requestService: FinanceRequestServiceProtocol
    
    var hasError = false
    @Published var isLoading = false
    @Published var selectedDay = 0
    
    private(set) var bonusImageName = "CoinIcon24"
    private(set) var balanceSectionTitle = "Balance"
    private(set) var transactionsSectionTitle = "Transactions"
    
    var entity = FinanceEntity()
    
    @AutoCancellable var task: Cancellable?
    
    init(
        router: FinanceRouterProtocol,
        requestService: FinanceRequestServiceProtocol
    ) {
        self.router = router
        self.requestService = requestService
    }
    
    func onAppear() {
        loadData()
    }
}
