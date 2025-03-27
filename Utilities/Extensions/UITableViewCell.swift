//
//  UITableViewCell.swift
//  Utilities
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import UIKit

extension UITableViewCell {
    
    public func updateSeperator(_ isLastElement: Bool) {
        separatorInset = isLastElement
        ? UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
