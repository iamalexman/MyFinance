//
//  FinanceLegacyEmptyView+Model.swift
//  UIKitComponents
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import UIKit

extension FinanceLegacyEmptyView {
    
    public struct Model {
        
        public var title: String
        public var imageName: String
        public var imageColor: UIColor?
        public var buttonTitle: String?
        public var buttonAction: (() -> Void)?
        
        public init(
            title: String,
            imageName: String,
            imageColor: UIColor? = nil,
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
