// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

struct CreateWalletViewModel {

    var _tittle: String?

    var title: String {
        set {
            _tittle = newValue
        }
        get {
            if "".kStringIsEmpty(_tittle) {
//                return "New Wallet"
//                return R.string.localizable.mainWallet()
                return "MainWallet".localized()

            } else {
                return _tittle!
            }
        }
    }

    var _password: String?

    var password: String {
        set {
            _password = newValue
        }
        get {
            if "".kStringIsEmpty(_password) {
                return ""
            } else {
                return _password!
            }
        }
    }

    init (
        title: String,
        password: String
        ) {
        self.title = title
        self.password = password
    }
}
