// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import TrustCore
import TrustKeystore

protocol TokensCoordinatorDelegate: class {
    func didSelect(wallet: WalletInfo, in coordinator: TokensCoordinator)
    func didPressSend(for token: TokenObject, in coordinator: TokensCoordinator)
    func didPressRequest(for token: TokenObject, in coordinator: TokensCoordinator)
    func didPress(url: URL, in coordinator: TokensCoordinator)
    func didPressDiscover(in coordinator: TokensCoordinator)
    func didRestart(with account: WalletInfo, in coordinator: TokensCoordinator)
}

final class TokensCoordinator: Coordinator {

    let navigationController: NavigationController
    let session: WalletSession
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage

    lazy var tokensViewController: MLTokensViewController = {
        let tokensViewModel = TokensViewModel(session: session, store: store, tokensNetwork: network, transactionStore: transactionsStore)
        let controller = MLTokensViewController(viewModel: tokensViewModel)
        controller.delegate = self
        return controller
    }()
    lazy var nonFungibleTokensViewController: NonFungibleTokensViewController = {
        let nonFungibleTokenViewModel = NonFungibleTokenViewModel(address: session.account.address, storage: store, tokensNetwork: network)
        let controller = NonFungibleTokensViewController(viewModel: nonFungibleTokenViewModel)
        controller.delegate = self
        return controller
    }()
    lazy var masterViewController: WalletViewController = {
        let masterViewController = WalletViewController(
            tokensViewController: tokensViewController,
            nonFungibleTokensViewController: nonFungibleTokensViewController
        )
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(R.image.ml_wallet_home_btnmenu(), for: UIControlState())
        rightBtn.addTarget(self, action: #selector(showMenuList), for: UIControlEvents.touchUpInside)
        masterViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        return masterViewController
    }()


    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        navigationController.popViewController(animated: false)
    }

    lazy var managerWalletVC: MLManagerWalletViewController = {
        let managerWalletVC = MLManagerWalletViewController(keystore: keystore)
        managerWalletVC.delegate = self
        return managerWalletVC
    }()

    //    lazy var walletsCoordinator: WalletsCoordinator = {
    //        let coordinator = WalletsCoordinator(keystore: keystore, navigationController: navigationController)
    ////        coordinator.delegate = self
    //        coordinator.start()
    ////        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    //        return coordinator
    //    }()

    weak var delegate: TokensCoordinatorDelegate?

    lazy var rootViewController: WalletViewController = {
        return masterViewController
    }()

    lazy var network: NetworkProtocol = {
        return TrustNetwork(
            provider: TrustProviderFactory.makeProvider(),
            wallet: session.account
        )
    }()

    init(
        navigationController: NavigationController = NavigationController(),
        session: WalletSession,
        keystore: Keystore,
        tokensStorage: TokensDataStore,
        transactionsStore: TransactionsStorage
        ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.keystore = keystore
        self.store = tokensStorage
        self.transactionsStore = transactionsStore
    }

    func start() {
        showTokens()
    }

    func showTokens() {
        navigationController.viewControllers = [rootViewController]
    }

    func presentCreateOrImportWallet(entryPoint: WalletEntryPoint) {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.delegate = self
        addCoordinator(coordinator)
        coordinator.start(entryPoint)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
    }
    func newTokenViewController(token: ERC20Token?) -> NewTokenViewController {
        let viewModel = NewTokenViewModel(token: token, session: session, tokensNetwork: network)
        let controller = NewTokenViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
    }

    func editTokenViewController(token: TokenObject) -> NewTokenViewController {
        let token: ERC20Token? = {
            guard let address = EthereumAddress(string: token.contract) else {
                return .none
            }
            return ERC20Token(contract: address, name: token.name, symbol: token.symbol, decimals: token.decimals, coin: token.coin)
        }()
        return newTokenViewController(token: token)
    }

    @objc func showMenuList() {
        navigationController.view.addSubview(managerWalletVC.view)
        managerWalletVC.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH!)
        managerWalletVC.start()
    }
    @objc func addToken() {
        let controller = newTokenViewController(token: .none)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
        let nav = NavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        navigationController.present(nav, animated: true, completion: nil)
    }

    func editToken(_ token: TokenObject) {
        let controller = editTokenViewController(token: token)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
        let nav = NavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        navigationController.present(nav, animated: true, completion: nil)
    }

    func tokenInfo(_ token: TokenObject) {
        let coordinator = TokenInfoCoordinator(token: token)
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }

    @objc func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }

    @objc func edit() {
        let controller = EditTokensViewController(
            session: session,
            storage: store,
            network: network
        )
        controller.delegate = self
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToken))
        navigationController.pushViewController(controller, animated: true)
    }

    private func openURL(_ url: URL) {
        delegate?.didPress(url: url, in: self)
    }

    func addTokenContract(for contract: Address) {
        let _ = network.search(query: contract.description).done { [weak self] tokens in
            guard let token = tokens.first else { return }
            self?.store.add(tokens: [token])
        }
    }

    @objc private func collectibles() {
        navigationController.pushViewController(nonFungibleTokensViewController, animated: true)
    }

    @objc private func transactions() {
        //let coordinator = TransactionsCoordinator(session: session, storage: transactionsStore, network: network)
        //navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }

    private func didSelectToken(_ token: CollectibleTokenObject, with backgroundColor: UIColor) {
        let controller = NFTokenViewController(token: token, server: session.currentRPC)
        controller.delegate = self
        controller.imageView.backgroundColor = backgroundColor
        navigationController.pushViewController(controller, animated: true)
    }

    func showWalletInfo(for wallet: WalletInfo, account: Account, sender: UIView) {
        let controller = WalletInfoViewController(
            wallet: wallet
        )
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    func exportMnemonic(for account: Wallet) {
        navigationController.topViewController?.displayLoading()
        keystore.exportMnemonic(wallet: account) { [weak self] result in
            self?.navigationController.topViewController?.hideLoading()
            switch result {
            case .success(let words):
                self?.exportMnemonicCoordinator(for: account, words: words)
            case .failure(let error):
                self?.navigationController.topViewController?.displayError(error: error)
            }
        }
    }

    func exportPrivateKeyView(for account: Account) {
        navigationController.topViewController?.displayLoading()
        keystore.exportPrivateKey(account: account) { [weak self] result in
            self?.navigationController.topViewController?.hideLoading()
            switch result {
            case .success(let privateKey):
                self?.exportPrivateKey(with: privateKey)
            case .failure(let error):
                self?.navigationController.topViewController?.displayError(error: error)
            }
        }
    }

    func exportMnemonicCoordinator(for account: Wallet, words: [String]) {
        let coordinator = ExportPhraseCoordinator(
            keystore: keystore,
            account: account,
            words: words
        )
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }

    func exportKeystore(for account: Account) {
        let coordinator = BackupCoordinator(
            navigationController: navigationController,
            keystore: keystore,
            account: account
        )
        coordinator.delegate = self
        coordinator.start()
        addCoordinator(coordinator)
    }

    func exportPrivateKey(with privateKey: Data) {
        let coordinator = ExportPrivateKeyCoordinator(privateKey: privateKey)
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }

    func pushCoordinator(pushType: MLPushType) {
        switch pushType {
        case .QRCode:
            presentQRCodeReaderCoordinator()
        case .CreateWallte:
            presentWalletCoordinator(entryPoint: .createInstantWallet)
        case .ImportWallte:
            presentWalletCoordinator(entryPoint: .importWallet)
        case .Setting:
            presentSettingCoordinator()
        default: break
        }
    }

    //二维码
    func presentQRCodeReaderCoordinator() {
        let coordinator = ScanQRCodeCoordinator(
            navigationController: NavigationController()
        )
        coordinator.delegate = self
        addCoordinator(coordinator)
        navigationController.present(coordinator.qrcodeController, animated: true, completion: nil)
    }
    //钱包
    func presentWalletCoordinator(entryPoint: WalletEntryPoint) {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.delegate = self
        addCoordinator(coordinator)
        coordinator.start(entryPoint)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
    }
    func presentSettingCoordinator() {
        let settingsCoordinator = SettingsCoordinator(
            keystore: keystore,
            session: session,
            storage: session.transactionsStorage,
            walletStorage: session.walletStorage,
            sharedRealm: session.sharedRealm
        )
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
        addCoordinator(settingsCoordinator)
        navigationController.present(settingsCoordinator.navigationController, animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TokensCoordinator: MLTokensViewControllerDelegate {
    func didRequest(token: TokenObject, in viewController: UIViewController) {
        delegate?.didPressRequest(for: token, in: self)
    }

    func didSelect(token: TokenObject, in viewController: UIViewController) {
        let controller = MLTokenViewController(
            viewModel: TokenViewModel(token: token, store: store, transactionsStore: transactionsStore, tokensNetwork: network, session: session)
        )
        controller.delegate = self
        //        controller.navigationItem.backBarButtonItem = .back
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        navigationController.pushViewController(controller, animated: true)
    }

    func didPressAddToken(in viewController: UIViewController) {
        addToken()
    }
}

extension TokensCoordinator: NewTokenViewControllerDelegate {
    func didAddToken(token: ERC20Token, in viewController: NewTokenViewController) {
        store.addCustom(token: token)
        tokensViewController.fetch()
        dismiss()
    }
}

extension TokensCoordinator: NonFungibleTokensViewControllerDelegate {
    func didPressDiscover() {
        delegate?.didPressDiscover(in: self)
    }

    func didPress(token: CollectibleTokenObject, with bacground: UIColor) {
        didSelectToken(token, with: bacground)
    }
}

extension TokensCoordinator: MLTokenViewControllerDelegate {
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController) {
        let controller = TransactionViewController(
            session: session,
            transaction: transaction,
            tokenViewModel: viewModel
        )
        controller.delegate = self
        NavigationController.openFormSheet(
            for: controller,
            in: navigationController,
            barItem: UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
        )
    }
    func didPressSend(for token: TokenObject, in controller: UIViewController) {
        delegate?.didPressSend(for: token, in: self)
    }

    func didPressRequest(for token: TokenObject, in controller: UIViewController) {
        delegate?.didPressRequest(for: token, in: self)
    }

    func didPressInfo(for token: TokenObject, in controller: UIViewController) {
        tokenInfo(token)
    }
}

extension TokensCoordinator: NFTokenViewControllerDelegate {
    func didPressLink(url: URL, in viewController: NFTokenViewController) {
        openURL(url)
    }
}

extension TokensCoordinator: TransactionViewControllerDelegate {
    func didPressURL(_ url: URL) {
        openURL(url)
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension TokensCoordinator: EditTokensViewControllerDelegate {
    func didDelete(token: TokenObject, in controller: EditTokensViewController) {
        store.delete(tokens: [token])
        controller.fetch()
    }

    func didDisable(token: TokenObject, in controller: EditTokensViewController) {
        store.update(tokens: [token], action: .disable(true))
    }

    func didEdit(token: TokenObject, in controller: EditTokensViewController) {
        editToken(token)
    }
}
extension TokensCoordinator: MLManagerWalletViewControllerDelegate {
    func didSelectForInfo(wallet: WalletInfo, account: Account, in controller: MLManagerWalletViewController) {
        showWalletInfo(for: wallet, account: account, sender: controller.view)
    }

    func didSelect(wallet: WalletInfo, account: Account, in controller: MLManagerWalletViewController) {
        delegate?.didSelect(wallet: wallet, in: self)
    }
    func didDeleteAccount(account: WalletInfo, in viewController: MLManagerWalletViewController) {
        viewController.fetch()

        //Remove Realm DB
        let db = RealmConfiguration.configuration(for: account)
        let fileManager = FileManager.default
        guard let fileURL = db.fileURL else { return }
        try? fileManager.removeItem(at: fileURL)
    }

    func didGoSettingVC(pushType: MLPushType) {
        self.pushCoordinator(pushType: pushType)
    }

    func didPresentVC(pushType: MLPushType) {
        self.pushCoordinator(pushType: pushType)
    }

    func didVDismissView() {
        managerWalletVC.end {
            self.managerWalletVC.view.removeFromSuperview()
        }
    }
}

extension TokensCoordinator: ScanQRCodeCoordinatorDelegate {
    func didCancel(in coordinator: ScanQRCodeCoordinator) {
        removeCoordinator(coordinator)
    }
    func didScan(result: String, in coordinator: ScanQRCodeCoordinator) {
        MLProgressHud.show(view: navigationController.view, status: .Success, state: result)
        removeCoordinator(coordinator)
    }
}

extension TokensCoordinator: WalletCoordinatorDelegate {
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }

    func didCancel(in coordinator: WalletCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }
}
extension TokensCoordinator: SettingsCoordinatorDelegate {
    func didRestart(with account: WalletInfo, in coordinator: SettingsCoordinator) {
        delegate?.didRestart(with: account, in: self)
        //         removeCoordinator(coordinator)
        //        navigationController.dismiss(animated: false)
    }

    func didPressURL(_ url: URL, in coordinator: SettingsCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }

    func didCancel(in coordinator: SettingsCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }
}

extension TokensCoordinator: BackupCoordinatorDelegate {
    func didCancel(coordinator: BackupCoordinator) {
        removeCoordinator(coordinator)
    }

    func didFinish(wallet: Wallet, in coordinator: BackupCoordinator) {
        removeCoordinator(coordinator)
    }
}

extension TokensCoordinator: WalletInfoViewControllerDelegate {
    func didPress(item: WalletInfoType, in controller: WalletInfoViewController) {
        switch item {
        case .exportKeystore(let account):
            exportKeystore(for: account)
        case .exportPrivateKey(let account):
            exportPrivateKeyView(for: account)
        case .exportRecoveryPhrase(let account):
            exportMnemonic(for: account)
        case .copyAddress(let address):
            controller.showShareActivity(from: controller.view, with: [address.description])
        }
    }

    func didPressSave(wallet: WalletInfo, fields: [WalletInfoField], in controller: WalletInfoViewController) {
        keystore.store(object: wallet.info, fields: fields)
        navigationController.popViewController(animated: true)
    }
}
