//
//  FinanceLegacyTableViewCellShimmering.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit
import UIKitComponents

// Transaction shimmering
final class FinanceLegacyTableViewCellShimmering: UITableViewCell {
    
    private let iconShimmering = ShimmeringAnimationView(
        width: 48,
        height: 48,
        cornerRadius: 24
    )
    
    private let titleShimmering = ShimmeringAnimationView(
        width: 120,
        height: 16,
        cornerRadius: 5
    )
    
    private let timeShimmering = ShimmeringAnimationView(
        width: 80,
        height: 14,
        cornerRadius: 4
    )
    
    private let amountShimmering = ShimmeringAnimationView(
        width: 60,
        height: 16,
        cornerRadius: 5
    )
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [iconShimmering,
         titleShimmering,
         timeShimmering,
         amountShimmering].forEach {
            $0.startShimmering()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [iconShimmering,
         titleShimmering,
         timeShimmering,
         amountShimmering].forEach {
            $0.stopShimmering()
        }
    }
    
    private func setup() {
        
        [iconShimmering,
         titleShimmering,
         timeShimmering,
         amountShimmering].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            iconShimmering.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconShimmering.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconShimmering.widthAnchor.constraint(equalToConstant: 48),
            iconShimmering.heightAnchor.constraint(equalToConstant: 48),
            
            titleShimmering.leadingAnchor.constraint(equalTo: iconShimmering.trailingAnchor, constant: 18),
            titleShimmering.topAnchor.constraint(equalTo: iconShimmering.topAnchor, constant: 2),
            titleShimmering.widthAnchor.constraint(equalToConstant: 120),
            titleShimmering.heightAnchor.constraint(equalToConstant: 16),
            
            timeShimmering.leadingAnchor.constraint(equalTo: iconShimmering.trailingAnchor, constant: 18),
            timeShimmering.bottomAnchor.constraint(equalTo: iconShimmering.bottomAnchor, constant: -2),
            timeShimmering.widthAnchor.constraint(equalToConstant: 80),
            timeShimmering.heightAnchor.constraint(equalToConstant: 14),
            
            amountShimmering.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountShimmering.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountShimmering.widthAnchor.constraint(equalToConstant: 60),
            amountShimmering.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}

extension FinanceLegacyTableViewCellShimmering: LegacyTableViewCellModelProtocol {
    
    func configure(with model: LegacyTableViewCellModel?) { }
}
