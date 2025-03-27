//
//  FinanceEmptyView+Model.swift
//  SwiftUIComponents
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import SwiftUI

extension FinanceEmptyView {
    
    public struct Model {
        
        public let title: String
        public let imageName: String
        public let imageColor: Color?
        public let buttonTitle: String?
        public let buttonAction: (() -> Void)?
        
        public init(
            title: String,
            imageName: String,
            imageColor: Color? = .gray.opacity(0.3),
            buttonTitle: String? = nil,
            buttonAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.imageName = imageName
            self.imageColor = imageColor
            self.buttonTitle = buttonTitle
            self.buttonAction = buttonAction
        }
    }
}
