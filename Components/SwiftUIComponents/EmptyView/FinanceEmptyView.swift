//
//  FinanceEmptyView.swift
//  SwiftUIComponents
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import SwiftUI

public struct FinanceEmptyView: View {
    
    private let model: Model
    
    public var body: some View {
        VStack(alignment: .center, spacing: Constants.spacing) {
            image
            title
            button
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var title: Text {
        Text(model.title)
            .font(.system(size: Constants.fontSize, weight: .semibold))
    }
    
    private var image: some View {
        Image(systemName: model.imageName)
            .resizable()
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .foregroundColor(model.imageColor)
    }
    
    @ViewBuilder
    private var button: some View {
        if let buttonAction = model.buttonAction {
            Button(action: buttonAction) {
                Text(model.buttonTitle ?? "")
                    .font(.system(size: Constants.fontSize, weight: .semibold))
            }
        }
    }
    
    public init(model: Model) {
        self.model = model
    }
}
