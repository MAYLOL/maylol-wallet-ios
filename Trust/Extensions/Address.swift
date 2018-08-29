// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

enum Errors: LocalizedError {
    case invalidAddress
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .invalidAddress:
            return NSLocalizedString("send.error.invalidAddress", value: "Invalid Address", comment: "")
        case .invalidAmount:
            return NSLocalizedString("send.error.invalidAmount", value: "Invalid Amount", comment: "")
        }
    }
}

extension EthereumAddress {
    static var zero: EthereumAddress {
        return EthereumAddress(string: "0x0000000000000000000000000000000000000000")!
    }
}
