// Copyright DApps Platform Inc. All rights reserved.

import RealmSwift
import TrustCore
import PromiseKit

final class NonFungibleTokenViewModel {

    let config: Config
    let storage: TokensDataStore
    var tokensNetwork: NetworkProtocol
    let tokens: Results<CollectibleTokenCategory>
    var tokensObserver: NotificationToken?
    let address: Address

    var title: String {
        return R.string.localizable.collectibles()
    }

    var headerBackgroundColor: UIColor {
        return UIColor(hex: "fafafa")
    }

    var headerTitleTextColor: UIColor {
        return AppStyle.collactablesHeader.textColor
    }

    var tableViewBacgroundColor: UIColor {
        return UIColor.white
    }

    var headerTitleFont: UIFont {
        return AppStyle.collactablesHeader.font
    }

    var headerBorderColor: UIColor {
        return UIColor(hex: "e1e1e1")
    }

    var hasContent: Bool {
        return !tokens.isEmpty
    }

    var cellHeight: CGFloat {
        return 240
    }

    init(
        address: Address,
        config: Config = Config(),
        storage: TokensDataStore,
        tokensNetwork: NetworkProtocol
    ) {
        self.address = address
        self.config = config
        self.storage = storage
        self.tokensNetwork = tokensNetwork
        self.tokens = storage.nonFungibleTokens
    }

    func fetchAssets() -> Promise<[CollectibleTokenCategory]> {
        return Promise { seal in
            firstly {
                tokensNetwork.collectibles()
            }.done { [weak self] tokens in
                self?.storage.add(tokens: tokens)
                seal.fulfill(tokens)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func setTokenObservation(with block: @escaping (RealmCollectionChange<Results<CollectibleTokenCategory>>) -> Void) {
        tokensObserver = tokens.observe(block)
    }

    func token(for path: IndexPath) -> CollectibleTokenObject {
        return tokens[path.section].items[path.row]
    }

    func tokens(for path: IndexPath) -> [CollectibleTokenObject] {
        return Array(tokens[path.section].items)
    }

    func cellViewModel(for path: IndexPath) -> NonFungibleTokenCellViewModel {
        return NonFungibleTokenCellViewModel(tokens: tokens(for: path))
    }

    func numberOfItems(in section: Int) -> Int {
        return 1
    }

    func numberOfSections() -> Int {
        return Array(tokens).map { $0.name }.count
    }

    func title(for section: Int) -> String {
        return tokens[section].name
    }

    func invalidateTokensObservation() {
        tokensObserver?.invalidate()
        tokensObserver = nil
    }
}
