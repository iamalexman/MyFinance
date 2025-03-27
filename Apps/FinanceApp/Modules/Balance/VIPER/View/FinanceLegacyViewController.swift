//
//  FinanceLegacyViewController.swift
//  FinanceApp
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit
import Utilities
import UIKitComponents

@MainActor protocol FinanceLegacyViewOutputProtocol: AnyObject {

    var isLoading: Bool { get }
    var selectedDay: Int { get set }
    var selectedDayName: String { get }
    var balance: FinanceLegacyEntity { get }
    
    func loadData()
    func viewDidLoad()
    func didPullToRefresh()
    func didTapRetryButton()
    func didSelectDay(index: Int)
}

@MainActor protocol FinanceLegacyViewInputProtocol: AnyObject {
    
    func updateBalance()
    func updateTransactions()
    func updateSegments(_ segments: [String])
    func updateEmptyView(_ model: FinanceLegacyEmptyView.Model)
}

@MainActor
final class FinanceLegacyViewController: UIViewController {
    
    private enum Constants {
        static let shimmeringCellsCount = 6
        static let baseColor = UIColor(named: "AccentColor")
        static let rowHeight: CGFloat = 85
        static let cardHeight: CGFloat = 150
    }
    
    var presenter: FinanceLegacyViewOutputProtocol?
    
    private var emptyView = FinanceLegacyEmptyView()
    
    private let balanceTitleLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let balanceCardView: UIView = {
        
        let view = UIView()
    
        view.backgroundColor = Constants.baseColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var bonusCoinImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var dayLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var amountLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var summaryLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var amountLabelShimmering: ShimmeringAnimationView = {
        
        let shimmeringView = ShimmeringAnimationView(
            width: 80,
            height: 24,
            cornerRadius: 7,
            isReversed: true
        )
        
        shimmeringView.translatesAutoresizingMaskIntoConstraints = false
        
        return shimmeringView
    }()
    
    private lazy var summaryLabelShimmering: ShimmeringAnimationView = {
        
        let shimmeringView = ShimmeringAnimationView(
            width: 80,
            height: 16,
            cornerRadius: 5,
            isReversed: true
        )
        
        shimmeringView.translatesAutoresizingMaskIntoConstraints = false
        
        return shimmeringView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        
        let segmentControl = UISegmentedControl()
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(
            self,
            action: #selector(daySelected),
            for: .valueChanged
        )
        
        return segmentControl
    }()
    
    private lazy var tableView: UITableView = {

        let tableView = UITableView()

        tableView.register(
            FinanceLegacyTableViewCell.self,
            forCellReuseIdentifier: FinanceLegacyTableViewCell.identifier
        )
        
        tableView.register(
            FinanceLegacyTableViewCellShimmering.self,
            forCellReuseIdentifier: FinanceLegacyTableViewCellShimmering.identifier
        )
        
        tableView.dataSource = self
        tableView.rowHeight = Constants.rowHeight
        tableView.allowsSelection = false
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        
        return refreshControl
    }()
    
    private let transactionsTitleLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    @objc private func refreshData(_ sender: UIButton) {
        presenter?.didPullToRefresh()
    }
    
    @objc private func daySelected(_ sender: UISegmentedControl) {
        presenter?.didSelectDay(index: sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        
        view.backgroundColor = .systemBackground
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        [dayLabel,
         amountLabel,
         summaryLabel,
         bonusCoinImageView,
         amountLabelShimmering,
         summaryLabelShimmering].forEach { balanceCardView.addSubview($0) }
        
        [balanceTitleLabel,
         balanceCardView,
         segmentControl,
         transactionsTitleLabel,
         tableView,
         emptyView].forEach { view.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            balanceTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            balanceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            balanceCardView.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 20),
            balanceCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            balanceCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            balanceCardView.heightAnchor.constraint(equalToConstant: Constants.cardHeight),
            
            dayLabel.topAnchor.constraint(equalTo: balanceCardView.topAnchor, constant: 20),
            dayLabel.leadingAnchor.constraint(equalTo: balanceCardView.leadingAnchor, constant: 16),
   
            bonusCoinImageView.bottomAnchor.constraint(equalTo: balanceCardView.bottomAnchor, constant: -25),
            bonusCoinImageView.leadingAnchor.constraint(equalTo: balanceCardView.leadingAnchor, constant: 16),
            
            amountLabel.leadingAnchor.constraint(equalTo: bonusCoinImageView.trailingAnchor, constant: 8),
            amountLabel.bottomAnchor.constraint(equalTo: balanceCardView.bottomAnchor, constant: -20),
            
            amountLabelShimmering.leadingAnchor.constraint(equalTo: bonusCoinImageView.trailingAnchor, constant: 12),
            amountLabelShimmering.centerYAnchor.constraint(equalTo: bonusCoinImageView.centerYAnchor),
            
            summaryLabel.trailingAnchor.constraint(equalTo: balanceCardView.trailingAnchor, constant: -16),
            summaryLabel.bottomAnchor.constraint(equalTo: balanceCardView.bottomAnchor, constant: -20),
            
            summaryLabelShimmering.trailingAnchor.constraint(equalTo: balanceCardView.trailingAnchor, constant: -16),
            summaryLabelShimmering.bottomAnchor.constraint(equalTo: amountLabelShimmering.bottomAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: balanceCardView.bottomAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            transactionsTitleLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 24),
            transactionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: transactionsTitleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

extension FinanceLegacyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.isLoading ?? true
        ? Constants.shimmeringCellsCount
        : presenter?.balance.sortedTransactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.isLoading ?? true
        ? dequeueShimmeringCell(for: indexPath)
        : dequeueFinanceCell(for: indexPath)
    }

    private func dequeueShimmeringCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FinanceLegacyTableViewCellShimmering.identifier,
            for: indexPath
        ) as? FinanceLegacyTableViewCellShimmering
        
        cell?.updateSeperator(indexPath.row == Constants.shimmeringCellsCount - 1)
        
        return cell ?? UITableViewCell()
    }

    private func dequeueFinanceCell(for indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FinanceLegacyTableViewCell.identifier,
            for: indexPath
        ) as? FinanceLegacyTableViewCell,
              let transaction = presenter?.balance.sortedTransactions[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: FinanceLegacyTableViewCellModel(
            typeLabel: transaction.type,
            titleLabel: transaction.title,
            timeLabel: transaction.timeStamp,
            amountLabel: transaction.amount.formatted().description,
            amountLabelColor: getColor(for: transaction.amount)
        ))
        
        cell.updateSeperator(transaction == presenter?.balance.sortedTransactions.last)
        
        return cell
    }
    
    private func getColor(for amount: Int) -> UIColor {
        amount > 0
        ? Constants.baseColor ?? .green
        : .red.withAlphaComponent(0.7)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ShimmeringProtocol)?.startShimmering()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ShimmeringProtocol)?.stopShimmering()
    }
}

extension FinanceLegacyViewController: FinanceLegacyViewInputProtocol {

    func updateBalance() {
        
        dayLabel.text = presenter?.selectedDayName
        amountLabel.text = presenter?.balance.bonusTotalString
        summaryLabel.text = presenter?.balance.totalAmountString
        balanceTitleLabel.text = presenter?.balance.balanceSectionTitle
        transactionsTitleLabel.text = presenter?.balance.transactionsSectionTitle
        bonusCoinImageView.image = UIImage(named: "\(presenter?.balance.bonusImageName ?? "")")
        
        updateCard()
    }
    
    private func updateCard() {
        
        let isLoading = presenter?.isLoading ?? true
        
        [amountLabel, summaryLabel].forEach { $0.isHidden = isLoading }
        [amountLabelShimmering, summaryLabelShimmering].forEach { $0.isHidden = !isLoading }
        
        handleShimmeringAnimation(isLoading)
        balanceCardView.layoutIfNeeded()
    }
    
    private func handleShimmeringAnimation(_ isLoading: Bool) {
        [amountLabelShimmering, summaryLabelShimmering].forEach {
            isLoading
            ? $0.startAnimation()
            : $0.stopAnimation()
        }
    }
    
    func updateSegments(_ segments: [String]) {
        
        segmentControl.removeAllSegments()
        
        segments.enumerated().forEach { index, title in
            segmentControl.insertSegment(
                withTitle: title,
                at: index,
                animated: false
            )
        }
        
        segmentControl.selectedSegmentIndex = presenter?.selectedDay ?? 0
    }
    
    func updateTransactions() {
        refreshControl.endRefreshing()
        emptyView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func updateEmptyView(_ model: FinanceLegacyEmptyView.Model) {
        emptyView.configure(with: model)
        emptyView.isHidden = false
        tableView.isHidden = true
        updateCard()
    }
}
