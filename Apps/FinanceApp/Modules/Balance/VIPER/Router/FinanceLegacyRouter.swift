//
//  FinanceLegacyRouter.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit

@MainActor protocol FinanceLegacyRouterInputProtocol {
    
    // Some methods for navigating to other screens
    // openDetails()...
}

@MainActor
final class FinanceLegacyRouter {
    
    weak var viewController: UIViewController?
    
    init() { }
}

extension FinanceLegacyRouter: FinanceLegacyRouterInputProtocol { }
