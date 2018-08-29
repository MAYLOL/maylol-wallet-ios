// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

struct ConfirmPaymentViewModel {

    let type: ConfirmType

    init(
        type: ConfirmType
    ) {
        self.type = type
    }

    var title: String {
        return NSLocalizedString("confirmPayment.confirm.button.title", value: "Confirm", comment: "")
    }

    var actionButtonText: String {
        switch type {
        case .sign:
            return R.string.localizable.approve()
        case .signThenSend:
            return R.string.localizable.send()
        }
    }

    var backgroundColor: UIColor {
        return .white
    }

    func getActionButtonText(_ status: BalanceStatus, config: Config, transfer: Transfer) -> String {
        if status.sufficient {
            return actionButtonText
        }

        let format = status.insufficientText
        let networkSymbol = transfer.server.symbol

        switch transfer.type {
        case .ether, .dapp:
            return String(format: format, networkSymbol)
        case .token(let token):
            switch status {
            case .token(let tokenSufficient, let gasSufficient):
                if !tokenSufficient {
                    return String(format: format, token.symbol)
                }
                if !gasSufficient {
                    return String(format: format, networkSymbol)
                }
                // should not be here
                return ""
            case .ether:
                // should not be here
                return ""
            }
        }
    }
}
