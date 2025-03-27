//
//  StartScreen.swift
//  MyFinance
//
//  Created by Alex Kuznetcov on 3/27/25.
//

import SwiftUI

struct StartScreen: View {
    
    @State private var isActive = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        if isActive {
            WelcomeScreen()
        } else {
            splashScreenView
        }
    }
    
    private var splashScreenView: some View {
        Image("SplashScreenImage")
            .resizable()
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    scale = 1.1
                }
                Task {
                    try await Task.sleep(nanoseconds: 1_500_000_000)
                    isActive = true
                }
            }
            .edgesIgnoringSafeArea(.all)
    }
}
