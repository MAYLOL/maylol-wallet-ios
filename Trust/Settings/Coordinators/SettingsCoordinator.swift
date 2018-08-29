// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import UIKit
import WebKit
import RealmSwift

protocol SettingsCoordinatorDelegate: class {
    func didRestart(with account: WalletInfo, in coordinator: SettingsCoordinator)
    func didPressURL(_ url: URL, in coordinator: SettingsCoordinator)
    func didCancel(in coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: Coordinator {

    let navigationController: NavigationController
    let keystore: Keystore
    let session: WalletSession
    let storage: TransactionsStorage
    let walletStorage: WalletStorage
    weak var delegate: SettingsCoordinatorDelegate?
    let pushNotificationsRegistrar = PushNotificationsRegistrar()
    var coordinators: [Coordinator] = []

//    lazy var rootViewController: SettingsViewController = {
//        let controller = SettingsViewController(
//            session: session,
//            keystore: keystore
//        )
//        controller.delegate = self
//        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
//        controller.modalPresentationStyle = .pageSheet
//        return controller
//    }()

    lazy var rootViewController: MLSettingsViewController = {
        let controller = MLSettingsViewController()
//        controller.modalPresentationStyle = .pageSheet
        controller.delegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        return controller
    }()



    let sharedRealm: Realm
    private lazy var historyStore: HistoryStore = {
        return HistoryStore(realm: sharedRealm)
    }()

    init(
        navigationController: NavigationController = NavigationController(),
        keystore: Keystore,
        session: WalletSession,
        storage: TransactionsStorage,
        walletStorage: WalletStorage,
        sharedRealm: Realm
    ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.keystore = keystore
        self.session = session
        self.storage = storage
        self.walletStorage = walletStorage
        self.sharedRealm = sharedRealm
    }

    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        delegate?.didCancel(in: self)
    }

    func start() {
        navigationController.viewControllers = [rootViewController]
//        presentSettingViewController()
    }

    func presentSettingViewController() {
        navigationController.pushViewController(rootViewController, animated: false)
    }
    func restart(for wallet: WalletInfo) {
        delegate?.didRestart(with: wallet, in: self)
    }

    func cleadCache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: { })
        }
        historyStore.clearAll()
    }

    private func showWallets() {
        let coordinator = WalletsCoordinator(keystore: keystore, navigationController: navigationController)
        coordinator.delegate = self
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }
    func settingAction(action: MLPushType, in viewController: UIViewController) {
        switch action {
        case .AboutUs:
            let controller = MLAboutUsViewController()
            controller.delegate = self
            navigationController.pushViewController(controller, animated: false)
        case .Unit:
            session.tokensStorage.clearBalance()
            restart(for: session.account)
        case .MutiLanguage:
            session.tokensStorage.clearBalance()
            restart(for: session.account)
        default:
            break
        }
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func didAction(action: SettingsAction, in viewController: SettingsViewController) {
        switch action {
        case .currency:
            session.tokensStorage.clearBalance()
            restart(for: session.account)
        case .pushNotifications(let change):
            switch change {
            case .state(let isEnabled):
                switch isEnabled {
                case true:
                    pushNotificationsRegistrar.register()
                case false:
                    pushNotificationsRegistrar.unregister()
                }
            case .preferences:
                pushNotificationsRegistrar.register()
            }
        case .openURL(let url):
            delegate?.didPressURL(url, in: self)
        case .clearBrowserCache:
            cleadCache()
            CookiesStore.delete()
        case .clearTransactions:
            session.transactionsStorage.deleteAll()
        case .clearTokens:
            session.tokensStorage.deleteAll()
        case .wallets:
            showWallets()
        }
    }
}

extension SettingsCoordinator: WalletsCoordinatorDelegate {
    func didPresentVC(pushType: MLPushType) {

    }

    func didVDismissView() {

    }

    func didGoSettingVC(pushType: MLPushType) {
     
    }

    func didCancel(in coordinator: WalletsCoordinator) {
        coordinator.navigationController.dismiss(animated: true)
    }

    func didUpdateAccounts(in coordinator: WalletsCoordinator) {
        //Refactor
        coordinator.navigationController.dismiss(animated: true)
    }

    func didSelect(wallet: WalletInfo, in coordinator: WalletsCoordinator) {
        coordinator.navigationController.removeChildCoordinators()
        delegate?.didRestart(with: wallet, in: self)
    }
}

extension SettingsCoordinator: MLSettingsViewControllerDelegate {
    func didAction(action: MLPushType, in viewController: MLSettingsViewController) {
        settingAction(action: action, in: viewController)
    }
}

extension SettingsCoordinator: MLAboutUsViewControllerDelegate {
    func didAction(action: MLPushType, in viewController: MLAboutUsViewController) {
        settingAction(action: action, in: viewController)
    }
}
