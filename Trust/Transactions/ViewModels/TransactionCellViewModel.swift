// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import UIKit
import TrustKeystore

struct TransactionCellViewModel {

    private let transaction: Transaction
    private let config: Config
    private let chainState: ChainState
    private let currentAccount: Account
    private let token: TokenObject
    private let shortFormatter = EtherNumberFormatter.short

    private let transactionViewModel: TransactionViewModel

    init(
        transaction: Transaction,
        config: Config,
        chainState: ChainState,
        currentAccount: Account,
        server: RPCServer,
        token: TokenObject
    ) {
        self.transaction = transaction
        self.config = config
        self.chainState = chainState
        self.currentAccount = currentAccount
        self.transactionViewModel = TransactionViewModel(
            transaction: transaction,
            config: config,
            currentAccount: currentAccount,
            server: server,
            token: token
        )
        self.token = token
    }

    private var operationTitle: String? {
        guard let operation = transaction.operation else { return .none }
        switch operation.operationType {
        case .tokenTransfer:
            return String(
                format: NSLocalizedString(
                    "transaction.cell.tokenTransfer.title",
                    value: "Transfer %@",
                    comment: "Transfer token title. Example: Transfer OMG"
                ),
                operation.symbol ?? ""
            )
        case .unknown:
            return .none
        }
    }

    var title: String {
        switch token.type {
        case .coin:
            return stateString
        case .ERC20:
            return operationTitle ?? stateString
        }
    }

    private var stateString: String {
        switch transaction.state {
        case .completed:
            switch transactionViewModel.direction {
            case .incoming:
                return NSLocalizedString("transaction.cell.received.title", value: "Received", comment: "")
            case .outgoing:
                return NSLocalizedString("transaction.cell.sent.title", value: "Sent", comment: "")
            }
        case .error:
            return NSLocalizedString("transaction.cell.error.title", value: "Error", comment: "")
        case .failed:
            return NSLocalizedString("transaction.cell.failed.title", value: "Failed", comment: "")
        case .unknown:
            return NSLocalizedString("transaction.cell.unknown.title", value: "Unknown", comment: "")
        case .pending:
            return NSLocalizedString("transaction.cell.pending.title", value: "Pending", comment: "")
        case .deleted:
            return ""
        }
    }

    var subTitle: String {
        if transaction.toAddress == nil {
            return NSLocalizedString("transaction.deployContract.label.title", value: "Deploy smart contract", comment: "")
        }
        switch transactionViewModel.direction {
        case .incoming:
            return String(
                format: "%@: %@",
                NSLocalizedString("transaction.from.label.title", value: "From", comment: ""),
                transactionViewModel.transactionFrom
            )
        case .outgoing:
            return String(
                format: "%@: %@",
                NSLocalizedString("transaction.to.label.title", value: "To", comment: ""),
                transactionViewModel.transactionTo
            )
        }
    }

    var subTitleTextColor: UIColor {
        return Colors.gray
    }

    var subTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
    }

    var backgroundColor: UIColor {
        switch transaction.state {
        case .completed, .error, .unknown, .failed, .deleted:
            return .white
        case .pending:
            return Colors.veryLightOrange
        }
    }

    var amountText: String {
        return transactionViewModel.amountText
    }

    var amountFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }

    var amountTextColor: UIColor {
        return transactionViewModel.amountTextColor
    }

    var statusImage: UIImage? {
        return transactionViewModel.statusImage
    }
}
