// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

enum Errors: LocalizedError {
    case invalidAddress
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .invalidAddress:
            return "ML.Send.error.invalidAddress.Error".localized()
        case .invalidAmount:
            return "ML.Send.error.invalidAmount.Error".localized()
        }
    }
}

extension EthereumAddress {
    static var zero: EthereumAddress {
        return EthereumAddress(string: "0x0000000000000000000000000000000000000000")!
    }
}
