//
//  FinanceRouter.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit

@MainActor protocol FinanceRouterProtocol {
    
    // Some methods for navigating to other screens
    // openDetails()...
}

@MainActor
final class FinanceRouter {
    
    weak var viewController: UIViewController?
    
    init() { }
}

extension FinanceRouter: FinanceRouterProtocol { }
