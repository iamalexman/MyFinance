//
//  ShimmeringView.swift
//  SwiftUIComponents
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import SwiftUI

public struct ShimmeringView: View {
    
    var isReversed: Bool
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    
    @State private var gradientPosition: CGFloat = -1
    
    private var animation: Animation {
        gradientPosition == 1
        ? Animation.easeIn(duration: 1.5).repeatForever(autoreverses: false)
        : .linear(duration: 0)
    }
    
    private var gradientColor: Color {
        isReversed
        ? Color.white.opacity(0.1)
        : Color.secondary.opacity(0.2)
    }
    
    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 0,
        isReversed: Bool = false
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.isReversed = isReversed
    }
    
    public var body: some View {
        ZStack {
            gradientColor
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
        .overlay(shimmeringGradient)
        .mask(RoundedRectangle(cornerRadius: cornerRadius))
        .animation(animation, value: gradientPosition)
        .onAppear { gradientPosition = 1 }
        .onDisappear { gradientPosition = -1 }
    }
    
    private var shimmeringGradient: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: gradientColor, location: 0.2),
                .init(color: gradientColor, location: 0.4),
                .init(color: gradientColor, location: 0.6),
                .init(color: .clear, location: 1)
            ],
            startPoint: .init(x: gradientPosition, y: 0),
            endPoint: .init(x: gradientPosition + 1, y: 0)
        )
    }
}
