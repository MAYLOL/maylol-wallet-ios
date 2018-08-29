// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import PromiseKit
import Crashlytics

struct NewTokenViewModel {

    private var tokensNetwork: NetworkProtocol
    let token: ERC20Token?
    private let session: WalletSession

    init(
        token: ERC20Token?,
        session: WalletSession,
        tokensNetwork: NetworkProtocol
    ) {
        self.token = token
        self.session = session
        self.tokensNetwork = tokensNetwork
    }

    var title: String {
        switch token {
        case .some:
            return NSLocalizedString("tokens.token.edit.navigation.title", value: "Edit Custom Token", comment: "")
        case .none:
            return NSLocalizedString("tokens.newtoken.navigation.title", value: "Add Custom Token", comment: "")
        }
    }

    var contract: String {
        return token?.contract.description ?? ""
    }

    var name: String {
        return token?.name ?? ""
    }

    var symbol: String {
        return token?.symbol ?? ""
    }

    var decimals: String {
        guard let decimals = token?.decimals else { return "" }
        return "\(decimals)"
    }

    var networkSelectorAvailable: Bool {
        return networks.count > 1
    }

    var network: RPCServer {
        guard let server = token?.coin.server else {
            if networkSelectorAvailable {
                return .main
            }
            return session.account.currentAccount.coin?.server ?? .main
        }
        return server
    }

    var networks: [RPCServer] {
        return session.account.accounts.compactMap { $0.coin?.server }
    }

    func info(for contract: String) -> Promise<TokenObject> {
        return Promise { seal in
            firstly {
                tokensNetwork.search(query: contract).firstValue
            }.done { token in
                seal.fulfill(token)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
