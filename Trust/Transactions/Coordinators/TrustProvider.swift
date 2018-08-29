// Copyright DApps Platform Inc. All rights reserved.

import Alamofire
import Foundation
import Moya

struct TrustProviderFactory {
    static let policies: [String: ServerTrustPolicy] = [
        :
//        Disabled until: https://github.com/TrustWallet/trust-wallet-ios/pull/129#issuecomment-353718512
//        "trustwalletapp.com": .pinPublicKeys(
//            publicKeys: ServerTrustPolicy.publicKeys(in: Bundle.main),
//            validateCertificateChain: true,
//            validateHost: true
//        ),
    ]

    static func makeProvider() -> MoyaProvider<TrustAPI> {
        let manager = Manager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        return MoyaProvider<TrustAPI>(manager: manager)
    }
}
