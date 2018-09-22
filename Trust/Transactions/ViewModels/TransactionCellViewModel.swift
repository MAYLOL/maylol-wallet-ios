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
                format: "ML.Transaction.cell.tokenTransfer%@.title".localized(),
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
//                return NSLocalizedString("transaction.cell.received.title", value: "Received", comment: "")
                return "ML.Transaction.cell.received.title".localized()
            case .outgoing:
//                return NSLocalizedString("transaction.cell.sent.title", value: "Sent", comment: "")
                return "ML.Transaction.cell.sent.title".localized()
            }
        case .error:
//            return NSLocalizedString("transaction.cell.error.title", value: "Error", comment: "")
            return "ML.Transaction.cell.error.title".localized()
        case .failed:
//            return NSLocalizedString("transaction.cell.failed.title", value: "Failed", comment: "")
            return "ML.Transaction.cell.failed.title".localized()
        case .unknown:
//            return NSLocalizedString("transaction.cell.unknown.title", value: "Unknown", comment: "")
            return "ML.Transaction.cell.unknown.title".localized()
        case .pending:
//            return NSLocalizedString("transaction.cell.pending.title", value: "Pending", comment: "")
            return "ML.Transaction.cell.pending.title".localized()
        case .deleted:
            return ""
        }
    }

    var subTitle: String {
        if transaction.toAddress == nil {
            return NSLocalizedString("transaction.deployContract.label.title", value: "Deploy smart contract", comment: "")
//            return "transaction.deployContract.label.title".localized()
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

    var detailSubTitle: String {
        if transaction.toAddress == nil {
            return NSLocalizedString("transaction.deployContract.label.title", value: "Deploy smart contract", comment: "")
        }
        switch transactionViewModel.direction {
        case .incoming:
            return transactionViewModel.transactionFrom
            //            return String(
            //                format: "%@: %@",
            //                NSLocalizedString("transaction.from.label.title", value: "From", comment: ""),
            //                transactionViewModel.transactionFrom
        //            )
        case .outgoing:
            return transactionViewModel.transactionTo
            //            return String(
            //                format: "%@: %@",
            //                NSLocalizedString("transaction.to.label.title", value: "To", comment: ""),
            //                transactionViewModel.transactionTo
            //            )
        }
    }

    var timeString: String {
        return NSDate.updateTime(forRow: transaction.date)
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
    var symbolAmountText: NSMutableAttributedString {
        var symbolStr = "+ "
        let amountText = transactionViewModel.noSymbolAmountText

        let attstr2 = NSMutableAttributedString(string: amountText)
        switch transaction.state {
        case .error, .unknown, .failed, .deleted:
            symbolStr = "+ "
            attstr2.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.f02e44color], range: NSRange(location: 0, length: attstr2.length))
        case .completed:
            switch transactionViewModel.direction {
            case .incoming:
                symbolStr = "+ "
                attstr2.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.f22222ecolor], range: NSRange(location: 0, length: attstr2.length))
            case .outgoing:
                symbolStr = "- "
                attstr2.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.f22222ecolor], range: NSRange(location: 0, length: attstr2.length))
            }
        case .pending:
            symbolStr = "+ "
            attstr2.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.f22222ecolor], range: NSRange(location: 0, length: attstr2.length))
        }

        let attstr = NSMutableAttributedString(string: symbolStr)
//        let str = symbolStr
        attstr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.f02e44color], range: NSRange(location: 0, length: symbolStr.length))
//
//        attstr2.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.strokeColor: Colors.titleBlackcolor], range: NSRange(location: 0, length: attstr2.length))
        attstr.append(attstr2)
        return attstr
    }

    //    switch transaction.state {
    //    case .error, .unknown, .failed, .deleted:
    //    //            return R.image.transaction_error()
    //    return R.image.ml_wallet_eth_icon_export()
    //    case .completed:
    //    switch direction {
    //    case .incoming:
    //    //                ml_wallet_eth_icon_import
    //    return R.image.ml_wallet_eth_icon_import()
    //    //                return R.image.transaction_received()
    //    case .outgoing:
    //    //                ml_wallet_eth_icon_export
    //    return R.image.ml_wallet_eth_icon_export()
    //    //                return R.image.transaction_sent()
    //    }
    //    case .pending:
    //    //            return R.image.transaction_pending()
    //    //                ml_wallet_eth_icon_export
    //    return R.image.ml_wallet_eth_icon_export()
    //    }

    var amountFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }

    var amountTextColor: UIColor {
        return transactionViewModel.amountTextColor
    }

    var statusImage: UIImage? {
        return transactionViewModel.statusImage
    }
    var statusdetailImage: UIImage? {
        return transactionViewModel.detailStatusImage
    }
}
