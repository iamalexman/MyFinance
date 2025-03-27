//
//  ModuleFactory.swift
//  MyFinance
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import SwiftUI
import Utilities
import FinanceApp
import FinanceContracts

@MainActor
public struct ModuleFactory {
    
    private let legacyBuilder: FinanceBuilderProtocol
    private let modernBuilder: FinanceBuilderProtocol
    private let requestService: FinanceRequestServiceProtocol = FinanceRequestService()
    
    public func makeLegacyModule() -> some View {
        UIViewControllerWrapper(viewController: legacyBuilder.build())
    }
    
    public func makeModernModule() -> some View {
        UIViewControllerWrapper(viewController: modernBuilder.build())
    }
    
    public init() {
        self.legacyBuilder = FinanceLegacyBuilder(requestService: requestService)
        self.modernBuilder = FinanceBuilder(requestService: requestService)
    }
}
