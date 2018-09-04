// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustKeystore
protocol MLManagerWalletCoordinatorDelegate: class {
    func didCancel(in coordinator: MLManagerWalletCoordinator)
}

final class MLManagerWalletCoordinator: Coordinator {
    let navigationController: NavigationController
    let session: WalletSession
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage
    let netWork: NetworkProtocol
    let tokensViewModel: TokensViewModel

    weak var delegate: MLManagerWalletCoordinatorDelegate?
    lazy var managerViewController: MLManagerWalletViewController = {
        var managerVC = MLManagerWalletViewController(
            keystore: keystore,
            session: session,
            tokensStorage: store,
            transactionsStore: transactionsStore,
            netWork: netWork,
            tokensViewModel: tokensViewModel)

        managerVC.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        managerVC.delegate = self
        return managerVC
    }()

    init(
        navigationController: NavigationController = NavigationController(),
        session: WalletSession,
        keystore: Keystore,
        tokensStorage: TokensDataStore,
        transactionsStore: TransactionsStorage,
        netWork: NetworkProtocol,
        tokensViewModel: TokensViewModel
        ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.keystore = keystore
        self.store = tokensStorage
        self.transactionsStore = transactionsStore
        self.netWork = netWork
        self.tokensViewModel = tokensViewModel
    }

    func start() {
        navigationController.viewControllers = [managerViewController]
    }

    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }
    func addLeftBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(popViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }
    //钱包
    func presentWalletCoordinator(entryPoint: WalletEntryPoint) {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.delegate = self
        addCoordinator(coordinator)
        coordinator.start(entryPoint)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
    }
    func presentWalletInfoViewController(account: WalletInfo) {
        let controller = MLWalletInfoViewController(wallet: account, keystore: keystore)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
    func presentPasswordViewController(wallet: WalletInfo) {
        let controller = MLChangePasswordViewController(keystore: keystore, wallet: wallet)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
    func doAction(action: ManagerActionType, wallet: WalletInfo) {
        switch action {
        case .changePassword:
            presentPasswordViewController(wallet: wallet)
        case .outputPrivate:
            exportPrivateKeyView(for: wallet.currentAccount)
        case .backsupMnemonic:
            break
//            exportMnemonic(for: wallet.currentAccount.wallet!)
        case .deleteWallet:
            break
        default:
            break
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
    func exportPrivateKey(with privateKey: Data) {
        let coordinator = ExportPrivateKeyCoordinator(privateKey: privateKey)
        coordinator.rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftBtn())
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }
    @objc func dismissViewController() {
        delegate?.didCancel(in: self)
    }
    @objc func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
extension MLManagerWalletCoordinator: MLManagerWalletViewControllerDelegate {
    func didPressWallet(account: WalletInfo, in viewController: MLManagerWalletViewController) {
        presentWalletInfoViewController(account: account)
    }
    func addWallet(entryPoint: WalletEntryPoint, in viewController:  MLManagerWalletViewController) {
        presentWalletCoordinator(entryPoint: entryPoint)
    }
    func didDeleteAccount(account: WalletInfo, in viewController: MLManagerWalletViewController) {
    }
}
extension MLManagerWalletCoordinator: WalletCoordinatorDelegate {
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }
    func didCancel(in coordinator: WalletCoordinator) {
        removeCoordinator(coordinator)
        navigationController.dismiss(animated: false)
    }
}
extension MLManagerWalletCoordinator: MLWalletInfoViewControllerDelegate {
    func didDeleteAccount(account: WalletInfo, in viewController: MLWalletInfoViewController) {
        //Remove Realm DB
        let db = RealmConfiguration.configuration(for: account)
        let fileManager = FileManager.default
        guard let fileURL = db.fileURL else { return }
        try? fileManager.removeItem(at: fileURL)
        navigationController.popViewController(animated: true)
    }

    func didAction(action: ManagerActionType, wallet: WalletInfo) {
        doAction(action: action, wallet: wallet)
    }

    func didCancel() {
        navigationController.popViewController(animated: true)
    }
    func didPreseSave(wallet: WalletInfo, fields: [WalletInfoField], controller: MLWalletInfoViewController) {
        keystore.store(object: wallet.info, fields: fields)
        navigationController.popRootViewController(animated: true)
//        navigationController.popViewController(animated: true)
    }
}

extension MLManagerWalletCoordinator: MLChangePasswordViewControllerDelegate {
    func didDismiss() {
        navigationController.popViewController(animated: true)
    }
    func didImport() {
        presentWalletCoordinator(entryPoint: .importWallet)
        navigationController.popViewController(animated: true)
    }
}
//extension MLManagerWalletCoordinator: PassphraseViewControllerDelegate {
//    func didPressVerify(in controller: PassphraseViewController, with account: Wallet, words: [String]) {}
//
//    func pushDone(in controller: PassphraseViewController, with account: Wallet) {
//        keystore.store(object: , fields: [.backup(true)])
//        navigationController.popViewController(animated: true)
//    }
//}

