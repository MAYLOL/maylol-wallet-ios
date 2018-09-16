// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

struct ImportWalletViewModel {

    private let coin: CoinViewModel

    init(
        coin: Coin
    ) {
        self.coin = CoinViewModel(coin: coin)
    }

    var title: String {
        return "importWallet.import.button.title".localized() + " " + coin.name
    }

    var keystorePlaceholder: String {
        return R.string.localizable.keystoreJSON()
    }

    var mnemonicPlaceholder: String {
//        return R.string.localizable.phrase()
        return "ML.Phrase".localized()
    }

    var privateKeyPlaceholder: String {
//        return R.string.localizable.privateKey()
        return "ML.PrivateKey".localized()
    }

    var watchAddressPlaceholder: String {
        return String(format: "import.wallet.watch.placeholder".localized(), coin.name)
    }
}
