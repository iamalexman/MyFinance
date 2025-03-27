//
//  ShimmeringAnimationView.swift
//  UIKitComponents
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit

public protocol ShimmeringProtocol {
    
    func startShimmering()
    func stopShimmering()
}

public final class ShimmeringAnimationView: UIView {
    
    private var isReversed: Bool?
    private var gradientLayer: CAGradientLayer?
    private var animation: CABasicAnimation?
    
    private var gradientColor: UIColor {
        isReversed ?? false
        ? UIColor.white.withAlphaComponent(0.1)
        : UIColor.secondaryLabel.withAlphaComponent(0.1)
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            updateGradientMask()
        }
    }
    
    public var backgroundColorShimmering: UIColor = .systemGray5 {
        didSet {
            backgroundView.backgroundColor = backgroundColorShimmering
        }
    }
    
    private let backgroundView = UIView()
    
    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 0,
        isReversed: Bool? = nil
    ) {
        super.init(frame: .zero)
        self.isReversed = isReversed
        self.cornerRadius = cornerRadius
        setupView(width: width, height: height)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
        updateGradientMask()
        backgroundView.layer.cornerRadius = cornerRadius
    }
    
    private func setup() {
        backgroundColorShimmering = gradientColor
        setupBackgroundView()
        setupGradient()
        setupAnimation()
    }
    
    private func setupBackgroundView() {
        
        backgroundView.backgroundColor = backgroundColorShimmering
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.masksToBounds = true
        
        addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupView(width: CGFloat?, height: CGFloat?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func setupGradient() {
        
        let layer = CAGradientLayer()
        
        layer.colors = [
            UIColor.clear.cgColor,
            gradientColor.cgColor,
            gradientColor.cgColor,
            UIColor.clear.cgColor
        ]
        
        layer.locations = [0, 0.2, 0.4, 1]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.addSublayer(layer)
        
        gradientLayer = layer
    }
    
    private func setupAnimation() {
        
        let animation = CABasicAnimation(keyPath: "locations")
        
        animation.fromValue = [-1.0, -0.8, -0.4, 0.0]
        animation.toValue = [1.0, 1.4, 1.6, 2.0]
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.repeatCount = .infinity
        
        self.animation = animation
    }
    
    public func startAnimation() {
        
        guard let gradientLayer,
              let animation else {
            return
        }
        
        gradientLayer.removeAllAnimations()
        gradientLayer.add(animation, forKey: "shimmering")
    }
    
    public func stopAnimation() {
        gradientLayer?.removeAllAnimations()
    }
    
    private func updateGradientFrame() {
        gradientLayer?.frame = bounds
    }
    
    private func updateGradientMask() {
        
        let mask = CAShapeLayer()
        
        mask.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        
        mask.fillColor = UIColor.black.cgColor
        
        gradientLayer?.mask = mask
    }
}

extension ShimmeringAnimationView: ShimmeringProtocol {
    
    public func startShimmering() { startAnimation() }
    public func stopShimmering() { stopAnimation() }
}
