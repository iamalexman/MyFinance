//
//  FinanceLegacyTableViewCell.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit
import UIKitComponents

public class FinanceLegacyTableViewCell: UITableViewCell {
    
    public var typeLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .label
        label.font = .systemFont(ofSize: 48)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var timeLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var amountLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .label
        label.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var infoStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public var transactionStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public override init(
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setup() {
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(timeLabel)
        
        transactionStackView.addArrangedSubview(typeLabel)
        transactionStackView.addArrangedSubview(infoStackView)
        transactionStackView.addArrangedSubview(amountLabel)
        
        contentView.addSubview(transactionStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            transactionStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            transactionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            transactionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

extension FinanceLegacyTableViewCell: LegacyTableViewCellModelProtocol {
    
    public func configure(with model: LegacyTableViewCellModel?) {
        
        guard let model = model as? FinanceLegacyTableViewCellModel else {
            return
        }
        
        update(model)
    }
    
    public func update(_ cellModel: FinanceLegacyTableViewCellModel) {
        typeLabel.text = cellModel.typeLabel
        titleLabel.text = cellModel.titleLabel
        timeLabel.text = cellModel.timeLabel
        amountLabel.text = cellModel.amountLabel
        amountLabel.textColor = cellModel.amountLabelColor
    }
}
