//
//  FinanceLegacyTableViewCellModel.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit
import UIKitComponents

public final class FinanceLegacyTableViewCellModel: LegacyTableViewCellModel {
    
    public let typeLabel: String
    public let titleLabel: String
    public let timeLabel: String
    public let amountLabel: String
    public let amountLabelColor: UIColor
    
    public init(
        typeLabel: String,
        titleLabel: String,
        timeLabel: String,
        amountLabel: String,
        amountLabelColor: UIColor
    ) {
        self.typeLabel = typeLabel
        self.titleLabel = titleLabel
        self.timeLabel = timeLabel
        self.amountLabel = amountLabel
        self.amountLabelColor = amountLabelColor
        
        super.init(identifier: FinanceLegacyTableViewCell.identifier,
                   cellClass: FinanceLegacyTableViewCell.self)
    }
}
