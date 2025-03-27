//
//  UIViewControllerWrapper.swift
//  Utilities
//
//  Created by Alex Kuznetcov on 3/31/25.
//

import UIKit
import SwiftUI

public struct UIViewControllerWrapper: UIViewControllerRepresentable {
    
    let viewController: UIViewController
    
    public func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

