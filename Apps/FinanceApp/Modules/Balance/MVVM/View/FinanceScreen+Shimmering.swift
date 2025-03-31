//
//  FinanceScreen+Shimmering.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/29/25.
//

import SwiftUI
import SwiftUIComponents

extension FinanceScreen {
    
    var balanceCardShimmering: some View {
        VStack(alignment: .leading) {
            Text(viewModel.entity.weekDays[safe: selectedDay]?.uppercased() ?? "")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.vertical, Constants.verticalPadding)
                .padding(.horizontal, Constants.horizontalPadding)
            Spacer()
            HStack(alignment: .bottom) {
                HStack(alignment: .center, spacing: 12) {
                    Image(viewModel.bonusImageName)
                    ShimmeringView(width: 80, height: 24, cornerRadius: 7, isReversed: true)
                }
                Spacer()
                ShimmeringView(width: 80, height: 16, cornerRadius: 5, isReversed: true)
            }
            .padding(.vertical, 25)
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.cardHeight)
        .background(Color.accentColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    var transactionsShimmering: some View {
        ForEach(0..<5) { index in transactionShimmering
            if index < 4 {
                Divider()
                    .padding(.leading, Constants.horizontalPadding)
            }
        }
    }
    
    private var transactionShimmering: some View {
        HStack(spacing: 18) {
            ShimmeringView(width: 48, height: 48, cornerRadius: 24)
            VStack(alignment: .leading, spacing: 14) {
                ShimmeringView(width: 120, height: 16, cornerRadius: 5)
                ShimmeringView(width: 80, height: 14, cornerRadius: 4)
            }
            .padding(.vertical, 5)
            Spacer()
            ShimmeringView(width: 60, height: 16, cornerRadius: 5)
        }
        .padding(Constants.horizontalPadding)
    }
}
