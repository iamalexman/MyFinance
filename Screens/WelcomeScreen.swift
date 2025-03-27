//
//  WelcomeScreen.swift
//  MyFinance
//
//  Created by Alex Kuznetcov on 3/27/25.
//

import SwiftUI
import Network
import FinanceApp
import FinanceContracts

struct WelcomeScreen: View {
    
    private let factory = ModuleFactory()
        
    var body: some View {
        NavigationStack {
            VStack {
                appHeader
                buttons
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    private var appHeader: some View {
        VStack(spacing: 0) {
            Image("AppIcon200")
            Text("MyFinance")
                .font(.system(size: 32, weight: .semibold))
                .scaledToFit()
        }
        .frame(maxHeight: .infinity)
    }
    
    private var buttons: some View {
        VStack(spacing: 16) {
            legacyModuleNavLink
            modernModuleNavLink
        }
    }
    
    private var legacyModuleNavLink: some View {
        NavigationLink {
            factory.makeLegacyModule()
        } label: {
            Text("UIKit + VIPER")
                .font(.system(size: 25, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var modernModuleNavLink: some View {
        NavigationLink {
            factory.makeModernModule()
        } label: {
            Text("SwiftUI + MVVM")
                .font(.system(size: 25, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
