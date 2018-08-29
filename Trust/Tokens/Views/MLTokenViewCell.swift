// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import Kingfisher
import RealmSwift
import TrustCore

final class MLTokenViewCell: UITableViewCell {

    static let identifier = "MLTokenViewCell"

    lazy var backView: UIView = {
        var backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = Colors.f2f2f2color
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        return backView
    }()
    lazy var containerForImageView: UIView = {
        var containerForImageView = UIView()
        containerForImageView.translatesAutoresizingMaskIntoConstraints = false
        return containerForImageView
    }()
    lazy var symbolImageView: TokenImageView = {
        var symbolImageView = TokenImageView()
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
//        symbolImageView.image = R.image.backup_warning()
        return symbolImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return titleLabel
    }()
    lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right
        amountLabel.font = UIFont.boldSystemFont(ofSize: 24)
        amountLabel.textColor = Colors.f22222ecolor
        return amountLabel
    }()
    lazy var currencyAmountLabel: UILabel = {
        let currencyAmountLabel = UILabel()
        currencyAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyAmountLabel.textAlignment = .right
        currencyAmountLabel.font = UIFont.boldSystemFont(ofSize: 12)
        currencyAmountLabel.textColor = Colors.f22222ecolor
        return currencyAmountLabel
    }()
    private var pendingTokenTransactionsObserver: NotificationToken?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSeparatorInset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        addSubview(backView)
        backView.addSubview(containerForImageView)
//        containerForImageView.addSubview(symbolImageView)
        backView.addSubview(symbolImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(amountLabel)
        backView.addSubview(currencyAmountLabel)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backView.leftAnchor.constraint(equalTo: leftAnchor, constant: -10),
            backView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            backView.heightAnchor.constraint(equalToConstant: 65),
  symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
symbolImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            symbolImageView.widthAnchor.constraint(equalToConstant: 40),
            symbolImageView.heightAnchor.constraint(equalToConstant: 40),

            containerForImageView.centerXAnchor.constraint(equalTo: symbolImageView.centerXAnchor, constant: 0),
            containerForImageView.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor, constant: 0),
            containerForImageView.widthAnchor.constraint(equalToConstant: TokensLayout.cell.imageSize),
            containerForImageView.heightAnchor.constraint(equalToConstant: TokensLayout.cell.imageSize),
            titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
            titleLabel.centerXAnchor.constraint(equalTo: symbolImageView.centerXAnchor, constant: 0),

            amountLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -15),
            amountLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: -12),
            currencyAmountLabel.rightAnchor.constraint(equalTo: amountLabel.rightAnchor, constant: 0),
            currencyAmountLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 12),
            ])
    }
    func configure(viewModel: TokenViewCellViewModel) {

        containerForImageView.badge(text: badgeText(for: viewModel.viewModel.token, in: viewModel.store))

        titleLabel.text = viewModel.viewModel.token.symbol
        amountLabel.text = viewModel.amount
//        amountLabel.textColor = TokensLayout.cell.amountTextColor
//        amountLabel.font = viewModel.amountFont

        //        marketPrice.text = viewModel.marketPrice
        //        marketPrice.textColor = viewModel.marketPriceTextColor
        //        //        marketPrice.font = viewModel.marketPriceFont
        //
        //        marketPercentageChange.text = viewModel.percentChange
        //        marketPercentageChange.textColor = viewModel.percentChangeColor
        //        marketPercentageChange.font = viewModel.percentChangeFont

        var untStr = "≈ ¥"
        if Config().currency == .CNY {
        }else if Config().currency == .USD {
            untStr = "≈ $"
        }
        currencyAmountLabel.text = "\(untStr)" +  (viewModel.currencyAmount ?? "0")
        symbolImageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: viewModel.placeholderImage
        )

        backgroundColor = viewModel.backgroundColor
        observePendingTransactions(from: viewModel.store, with: viewModel.viewModel.token)
    }

    private func updateSeparatorInset() {
        separatorInset = UIEdgeInsets(
            top: 0,
            left: layoutInsets.left + TokensLayout.cell.stackVericalOffset + TokensLayout.cell.imageSize +  TokensLayout.cell.stackVericalOffset +  TokensLayout.cell.arrangedSubviewsOffset,
            bottom: 0, right: 0
        )
    }

    private func observePendingTransactions(from storage: TransactionsStorage, with token: TokenObject) {
        pendingTokenTransactionsObserver = storage.transactions.observe { [weak self] _ in
            guard let `self` = self else { return }
            self.containerForImageView.badge(text: self.badgeText(for: token, in: storage))
        }
    }

    func badgeText(for token: TokenObject, in storage: TransactionsStorage) -> String? {
        let items = storage.pendingObjects.filter {
            switch token.type {
            case .coin:
                return $0.coin == token.coin && $0.localizedOperations.isEmpty
            case .ERC20:
                return $0.contractAddress == token.contractAddress
            }
        }
        return items.isEmpty ? .none : String(items.count)
    }

    deinit {
        pendingTokenTransactionsObserver?.invalidate()
        pendingTokenTransactionsObserver = nil
    }
}

