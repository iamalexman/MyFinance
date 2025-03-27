//
//  FinanceLegacyPresenter.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import Utilities
import UIKitComponents

@MainActor
final class FinanceLegacyPresenter {
    
    weak var view: FinanceLegacyViewInputProtocol?
    let interactor: FinanceLegacyInteractorProtocol
    let router: FinanceLegacyRouterInputProtocol
    
    private(set) var hasError = false
    private(set) var isLoading = true
    
    var selectedDay = 0
    var balance: FinanceLegacyEntity { interactor.entity }
    var selectedDayName: String {
        balance.weekDays[safe: selectedDay]?.uppercased() ?? ""
    }
    
    @AutoCancellable private var task: Cancellable?
    
    init(
        view: FinanceLegacyViewInputProtocol?,
        interactor: FinanceLegacyInteractorProtocol,
        router: FinanceLegacyRouterInputProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func loadData() {
        clearData()
        updateBalance()
        asyncFetchData()
    }
    
    func clearData() {
        isLoading = true
        hasError = false
        interactor.entity.transactions = nil
    }
    
    func updateBalance() {
        
        updateSegments()
        
        isLoading
        ? updateFinanceShimmering()
        : updateFinance()
    }
    
    func asyncFetchData() {
        
        task?.cancel()
        
        task = Task {
            
            do {
                try await interactor.fetchData(selectedDay)
                hasError = false
            } catch {
                hasError = true
                interactor.entity.transactions = nil
            }
            
            guard !Task.isCancelled else { return }
            isLoading = false
            updateBalance()
        }
    }
    
    private func updateSegments() {
        view?.updateSegments(
            balance.weekDays.map { String($0.prefix(3)) }
        )
    }
    
    func updateFinanceShimmering() {
        view?.updateBalance()
        view?.updateTransactions()
    }
    
    func updateFinance() {
        
        view?.updateBalance()
        
        if hasError {
            updateEmptyView(with: failureModel)
        } else if balance.transactions?.isEmpty ?? true {
            updateEmptyView(with: emptyModel)
        } else {
            view?.updateTransactions()
        }
    }
}

extension FinanceLegacyPresenter: FinanceLegacyViewOutputProtocol {
    
    func viewDidLoad() {
        loadData()
    }
    
    func didPullToRefresh() {
        loadData()
    }
    
    func didSelectDay(index: Int) {
        guard selectedDay != index else { return }
        selectedDay = index
        loadData()
    }
    
    func didTapRetryButton() {
        loadData()
    }
}
