// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustKeystore
import BigInt

struct section {
    let footer: String?
    let header: String?
    let rows: [WalletInfoType]

    init(footer: String? = .none, header: String? = .none, rows: [WalletInfoType]) {
        self.footer = footer
        self.header = header
        self.rows = rows
    }
}

enum ManagerActionType {
    case changeWalletName
    case changePassword
    case outputPrivate
    case backsupMnemonic
    case deleteWallet
}

struct MLWalletInfoViewModel {

    let wallet: WalletInfo
    private let shortFormatter = EtherNumberFormatter.short
    init(
        wallet: WalletInfo
        ) {
        self.wallet = wallet
    }
    var title: String {
        if wallet.multiWallet {
            return wallet.info.name
        }
//        if !wallet.info.name.isEmpty {
//            return  wallet.info.name + " (" + wallet.coin!.server.symbol + ")"
//        }
        if !wallet.info.name.isEmpty {
            return  wallet.info.name
        }
        return WalletInfo.emptyName
    }

    let titles: [String] = [
        "ML.Wallet.Name".localized(),
        "ML.Password.Change".localized(),
        "ML.Export.PrivateKey".localized()
    ]
    let action: [ManagerActionType] = [
        .changeWalletName,
        .changePassword,
        .outputPrivate,
    ]
    var address: String {
        return wallet.address.description
    }
    var balanceStr: String {
        guard !wallet.info.balance.isEmpty, let server = wallet.coin?.server else {
            return "0.0" + " ether"
        }
        return shortFormatter.string(from: BigInt(wallet.info.balance) ?? BigInt(), decimals: server.decimals) + " ether"
    }

    var name: String {
        if wallet.info.name.isEmpty {
            return WalletInfo.emptyName
        }
        return wallet.info.name
    }

    var nameTitle: String {
        return R.string.localizable.name()
    }

    var sections: [FormSection] {
        switch wallet.type {
        case .privateKey:
            return [
                FormSection(
                    rows: [
                        .exportKeystore(wallet.currentAccount),
                        .exportPrivateKey(wallet.currentAccount),
                        ]
                ),
                FormSection(
                    footer: wallet.currentAccount.address.description,
                    rows: [
                        .copyAddress(wallet.address),
                        ]
                ),
            ]
        case .hd(let account):
            if wallet.multiWallet {
                return [
                    FormSection(
                        footer: R.string.localizable.multiCoinWallet(),
                        rows: [
                            .exportRecoveryPhrase(account),
                            ]
                    ),
                ]
            }
            return [
                FormSection(
                    rows: [
                        .exportRecoveryPhrase(account),
                        .exportKeystore(wallet.currentAccount),
                        .exportPrivateKey(wallet.currentAccount),
                        ]
                ),
                FormSection(
                    footer: wallet.currentAccount.address.description,
                    rows: [
                        .copyAddress(wallet.address),
                        ]
                ),
            ]
        case .address(_, let address):
            return [
                FormSection(
                    footer: wallet.currentAccount.address.description,
                    rows: [
                        .copyAddress(address),
                        ]
                ),
            ]
        }
    }
}
