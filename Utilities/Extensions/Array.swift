//
//  Array.swift
//  Utilities
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
