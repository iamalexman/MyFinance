//
//  FinanceLegacyEmptyView.swift
//  UIKitComponents
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit

public final class FinanceLegacyEmptyView: UIView {
    
    public var model: Model?
    
    public lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(
            ofSize: Constants.fontSize,
            weight: .semibold
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    public lazy var actionButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(
            ofSize: Constants.fontSize,
            weight: .semibold
        )
        button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    public lazy var stackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            actionButton
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public var onButtonTap: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        onButtonTap?()
        onButtonTap = nil
    }
}

extension FinanceLegacyEmptyView: LegacyTableViewCellModelProtocol {
    
    public func configure(with model: Model) {
        titleLabel.text = model.title
        imageView.image = UIImage(systemName: model.imageName)
        imageView.tintColor = model.imageColor
        actionButton.setTitle(model.buttonTitle, for: .normal)
        actionButton.isHidden = model.buttonTitle == nil
        onButtonTap = model.buttonAction
    }
}
