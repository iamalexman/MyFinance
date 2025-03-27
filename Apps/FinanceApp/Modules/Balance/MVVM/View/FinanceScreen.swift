//
//  FinanceScreen.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import SwiftUI
import SwiftUIComponents

@MainActor protocol FinanceScreenModelProtocol: ObservableObject {
    
    var hasError: Bool { get }
    var isLoading: Bool { get }
    var selectedDay: Int { get set }
    var bonusImageName: String { get }
    var balanceSectionTitle: String { get }
    var transactionsSectionTitle: String { get }
    var entity: FinanceEntity { get }
    var failureModel: FinanceEmptyView.Model? { get }
    var emptyModel: FinanceEmptyView.Model? { get }
    
    func loadData()
}

enum Constants {
    static let cardHeight: CGFloat = 150
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 20
}

struct FinanceScreen<ViewModel>: View where ViewModel: FinanceScreenModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var selectedDay = 0
    
    var weekDays: [String] { viewModel.entity.weekDays }
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Section(header: balanceTitle) {
                balanceCard
                dayPicker
            }
            Section(header: transactionsTitle) {
                transactionsContent
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear { viewModel.loadData() }
    }
    
    @ViewBuilder private var transactionsContent: some View {
        if viewModel.hasError, !viewModel.isLoading {
            failure
        } else if viewModel.entity.transactions?.isEmpty ?? true, !viewModel.isLoading {
            empty
        } else {
            transactions
        }
    }
    
    private var dayPicker: some View {
        VStack {
            Picker("DayPicker", selection: $selectedDay) {
                ForEach(weekDays, id: \.self) {
                    Text($0.prefix(3))
                        .tag(weekDays.firstIndex(of: $0) ?? 0)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedDay) { newDay in
                viewModel.selectedDay = newDay
                viewModel.loadData()
            }
        }
        .padding()
    }
    
    private var balanceTitle: some View {
        Text(viewModel.balanceSectionTitle)
            .fontWeight(.semibold)
            .font(.title3)
            .padding(.horizontal)
            .padding(.vertical, Constants.verticalPadding)
    }
    
    @ViewBuilder private var balanceCard: some View {
        if viewModel.isLoading {
            balanceCardShimmering
        } else {
            balanceCardView
        }
    }
    
    private var balanceCardView: some View {
        VStack(alignment: .leading, spacing: Constants.verticalPadding) {
            Text(viewModel.entity.weekDays[safe: selectedDay]?.uppercased() ?? "")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
            
            HStack(alignment: .bottom) {
                HStack(alignment: .center) {
                    Image(viewModel.bonusImageName)
                    Text("\(viewModel.entity.bonusTotalString)")
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(viewModel.entity.totalAmountString)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.cardHeight)
        .background(Color.accentColor)
        .cornerRadius(10) .padding(.horizontal)
    }
    
    private var transactionsTitle: some View {
        Text(viewModel.transactionsSectionTitle)
            .fontWeight(.semibold)
            .font(.title3)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
    
    @ViewBuilder private var transactions: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.isLoading {
                    transactionsShimmering
                } else {
                    transactionsList
                }
            }
        }
        .refreshable {
            viewModel.loadData()
        }
    }
    
    private var transactionsList: some View {
        ForEach(viewModel.entity.sortedTransactions) {
            transaction in HStack {
                Text(transaction.type)
                    .frame(width: 50, height: 50, alignment: .center)
                    .font(.system(size: 48))
                VStack(alignment: .leading, spacing: 8) {
                    Text(transaction.title)
                    Text(transaction.timeStamp)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(transaction.amount)")
                    .font(
                        .system(.body, design: .monospaced))
                    .foregroundColor(transaction.amount > 0 ? .accentColor : .red)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, Constants.horizontalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            if transaction != viewModel.entity.sortedTransactions.last {
                Divider()
                    .padding(.leading, Constants.horizontalPadding)
            }
        }
    }
    
    @ViewBuilder var failure: some View {
        if let failureModel = viewModel.failureModel {
            FinanceEmptyView(model: failureModel)
        }
    }
    
    @ViewBuilder var empty: some View {
        if let emptyModel = viewModel.emptyModel {
            FinanceEmptyView(model: emptyModel)
        }
    }
}
