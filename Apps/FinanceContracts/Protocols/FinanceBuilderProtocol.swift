//
//  FinanceBuilderProtocol.swift
//  FinanceContracts
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit

@MainActor public protocol FinanceBuilderProtocol {
    
    func build() -> UIViewController
}
