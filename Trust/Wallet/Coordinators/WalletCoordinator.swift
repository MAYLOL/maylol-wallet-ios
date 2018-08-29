// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import TrustKeystore
import UIKit

protocol WalletCoordinatorDelegate: class {
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator)
    func didCancel(in coordinator: WalletCoordinator)
}

final class WalletCoordinator: Coordinator {

    let navigationController: NavigationController
    weak var delegate: WalletCoordinatorDelegate?
    var entryPoint: WalletEntryPoint?
    let keystore: Keystore
    var coordinators: [Coordinator] = []

    private var createWalletViewModel: CreateWalletViewModel = CreateWalletViewModel(title: "", password: "")

    init(
        navigationController: NavigationController = NavigationController(),
        keystore: Keystore
        ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.keystore = keystore
    }

    func start(_ entryPoint: WalletEntryPoint) {
        self.entryPoint = entryPoint
        switch entryPoint {
        case .welcome:
            //            if let _ = keystore.mainWallet {
            //                setSelectCoin()
            //            } else {
            setWelcomeView()
        //            }
        case .importWallet:
            //            if let _ = keystore.mainWallet {
            //                setSelectCoin()
            //            } else {
            setImportMainWallet()
        //            }
        case .createInstantWallet:
            setCreateWalletView()
            //            createInstantWallet(createWalletViewModel: self.createWalletViewModel)
        }
    }
    func setCreateWallet(createWalletViewModel: CreateWalletViewModel) {
        self.createWalletViewModel = createWalletViewModel
    }
    private func pushImportWalletView(for coin: Coin) {
        let controller = ImportWalletViewController(keystore: keystore, for: coin)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    private func setCreateWalletView() {
        let controller = MLCreateWalletViewController()
        controller.delegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        navigationController.viewControllers = [controller]
    }
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        dismiss()
    }

    private func setWelcomeView() {
        let controller = WelcomeViewController()
        controller.delegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationController.viewControllers = [controller]
    }

    func pushImportWallet() {
        if let _ = keystore.mainWallet {
            pushSelectCoin()
        } else {
            importMainWallet()
        }
    }

    //    func createInstantWallet() {
    //        let text = R.string.localizable.creatingWallet() + "..."
    //        navigationController.topViewController?.displayLoading(text: text, animated: false)
    //        let password = PasswordGenerator.generateRandom()
    //        keystore.createAccount(with: password) { result in
    //            switch result {
    //            case .success(let account):
    //                self.markAsMainWallet(for: account, walletName: nil)
    //                self.keystore.exportMnemonic(wallet: account) { mnemonicResult in
    //                    self.navigationController.topViewController?.hideLoading(animated: false)
    //                    switch mnemonicResult {
    //                    case .success(let words):
    //                        self.pushBackup(for: account, words: words, createWalletViewModel: createWalletViewModel
    //                    case .failure(let error):
    //                        self.navigationController.displayError(error: error)
    //                    }
    //                }
    //            case .failure(let error):
    //                self.navigationController.topViewController?.hideLoading(animated: false)
    //                self.navigationController.topViewController?.displayError(error: error)
    //            }
    //        }
    //    }

    func createInstantWallet(createWalletViewModel: CreateWalletViewModel) {
        let text = R.string.localizable.creatingWallet() + "..."
        navigationController.topViewController?.displayLoading(text: text, animated: false)
//        let password = PasswordGenerator.generateRandom()
        let password = createWalletViewModel.password
        keystore.createAccount(with: password) { result in
            switch result {
            case .success(let account):
                self.markAsMainWallet(for: account, walletName: createWalletViewModel.title)
                self.keystore.exportMnemonic(wallet: account) { mnemonicResult in
                    self.navigationController.topViewController?.hideLoading(animated: false)
                    switch mnemonicResult {
                    case .success(let words):
                        let type = WalletType.hd(account)
                        let wallet = WalletInfo(type: type, info: self.keystore.storage.get(for: type))
                        self.savePassWord(address: wallet.address.description, pwd: password)
                        self.pushBackup(for: account, words: words)
                    case .failure(let error):
                        self.navigationController.displayError(error: error)
                    }
                }
            case .failure(let error):
                self.navigationController.topViewController?.hideLoading(animated: false)
                self.navigationController.topViewController?.displayError(error: error)
            }
        }
    }

    func configureWhiteNavigation() {
        navigationController.navigationBar.tintColor = Colors.black
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    func pushBackup(for account: Wallet, words: [String]) {
        configureWhiteNavigation()
        let controller = DarkPassphraseViewController(
            account: account,
            words: words,
            mode: .showOnly
        )
        controller.delegate = self
        //        controller.navigationItem.backBarButtonItem = nil
        //        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(controller, animated: true)
    }

    func verifyPasswordVC(nav: NavigationController,session: WalletSession, completeHandle closure:@escaping ()->()) {

        let walletPasswordVC = MLWalletPasswordViewController(session: session)
        walletPasswordVC.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH!)
        walletPasswordVC.delegate = self
        nav.view.addSubview(walletPasswordVC.view)
        walletPasswordVC.start(successHandle: closure)
    }
    private func setImportMainWallet() {
        let controller = ImportNewMainWalletViewController(keystore: keystore, for: .ethereum)
        controller.delegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        navigationController.viewControllers = [controller]
    }

    func importMainWallet() {
        let controller = ImportMainWalletViewController(keystore: keystore)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    @objc func done() {
        delegate?.didCancel(in: self)
    }

    func dismiss() {
        delegate?.didCancel(in: self)
    }
    func didCreateAccount(account: WalletInfo) {
        delegate?.didFinish(with: account, in: self)
    }

    //    func verify(account: Wallet, words: [String]) {
    //        let controller = DarkVerifyPassphraseViewController(account: account, words: words)
    //        controller.delegate = self
    //        navigationController.setNavigationBarHidden(false, animated: true)
    //        navigationController.pushViewController(controller, animated: true)
    //    }

    //    func walletCreated(wallet: WalletInfo, type: WalletDoneType) {
    //        let controller = WalletCreatedController(viewModel: WalletCreatedViewModel(wallet: wallet, type: type))
    //        controller.delegate = self
    //        controller.navigationItem.backBarButtonItem = nil
    //        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    //        navigationController.setNavigationBarHidden(true, animated: true)
    //        navigationController.pushViewController(controller, animated: true)
    //    }

    private func pushSelectCoin() {
        let controller = SelectCoinViewController(coins: Config.current.servers)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    private func setSelectCoin() {
        let controller = SelectCoinViewController(coins: Config.current.servers)
        controller.delegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationController.viewControllers = [controller]
    }

    private func markAsMainWallet(for account: Wallet, walletName: String?) {
        let type = WalletType.hd(account)
        let wallet = WalletInfo(type: type, info: keystore.storage.get(for: type))
        let initialName = R.string.localizable.mainWallet()
        markAsMainWallet(for: wallet, walletName: walletName ?? initialName)
    }

    private func markAsMainWallet(for wallet: WalletInfo, walletName: String?) {
        let mainWalletName = R.string.localizable.mainWallet()
        let initialName = walletName ?? mainWalletName
        keystore.store(object: wallet.info, fields: [
            .name(initialName),
            .mainWallet(true),
            ])
    }

    private func showConfirm(for account: Wallet, completedBackup: Bool) {
        let type = WalletType.hd(account)
        let wallet = WalletInfo(type: type, info: keystore.storage.get(for: type))
        showConfirm(for: wallet, type: .created, completedBackup: completedBackup)
    }

    private func showConfirm(for wallet: WalletInfo, type: WalletDoneType, completedBackup: Bool) {
        keystore.store(object: wallet.info, fields: [
            .backup(completedBackup),
            ])
        //        walletCreated(wallet: wallet, type: type)
        done(for: wallet)
    }

    func done(for wallet: WalletInfo) {
        didCreateAccount(account: wallet)
    }
    func savePassWord(address: String, pwd: String) {
        let keychain = MLKeychain()
        keychain.saveKeychain(service: address, data: pwd as AnyObject)
    }

    func didFinishVerifyPassword(vc: MLWalletPasswordViewController) {
        
//        session.tokensStorage.clearBalance()
//        restart(for: session.account)
//        walletPasswordVC.end {
//            self.walletPasswordVC.view.removeFromSuperview()
//            self.removeCoordinator(self)
//        }
    }
    func dismissVerifyPassword(vc: MLWalletPasswordViewController) {
        vc.end {
            vc.view.removeFromSuperview()
            self.removeCoordinator(self)
        }
    }
}

extension WalletCoordinator: WelcomeViewControllerDelegate {

    func didPressCreateWallet(in viewController: WelcomeViewController, createWalletViewModel: CreateWalletViewModel) {
        createInstantWallet(createWalletViewModel: createWalletViewModel)
    }

    func didPressImportWallet(in viewController: WelcomeViewController) {
        pushImportWallet()
    }

    //    func didPressCreateWallet(in viewController: WelcomeViewController) {
    //        createInstantWallet()
    //    }
}

extension WalletCoordinator: ImportWalletViewControllerDelegate {
    func didImportAccount(account: WalletInfo, fields: [WalletInfoField], in viewController: ImportWalletViewController) {
        keystore.store(object: account.info, fields: fields)
        //        walletCreated(wallet: account, type: .imported)
        done(for: account)
    }
}

extension WalletCoordinator: PassphraseViewControllerDelegate {
    func pushDone(in controller: PassphraseViewController, with account: Wallet) {
        self.showConfirm(for: account, completedBackup: false)
    }
    func didPressVerify(in controller: PassphraseViewController, with account: Wallet, words: [String]) {
        // show verify
        //        verify(account: account, words: words)
        self.showConfirm(for: account, completedBackup: false)
    }
}

extension WalletCoordinator: VerifyPassphraseViewControllerDelegate {
    func didFinish(in controller: VerifyPassphraseViewController, with account: Wallet) {
        showConfirm(for: account, completedBackup: true)
    }

    func didSkip(in controller: VerifyPassphraseViewController, with account: Wallet) {
        controller.confirm(
            title: NSLocalizedString("verifyPassphrase.skip.confirm.title", value: "Are you sure you want to skip this step?", comment: ""),
            message: NSLocalizedString("verifyPassphrase.skip.confirm.message", value: "Loss of backup phrase can put your wallet at risk!", comment: ""),
            okTitle: R.string.localizable.skip(),
            okStyle: .destructive
        ) { [weak self] result in
            switch result {
            case .success:
                self?.showConfirm(for: account, completedBackup: false)
            case .failure: break
            }
        }
    }
}

extension WalletCoordinator: WalletCreatedControllerDelegate {
    func didPressDone(wallet: WalletInfo, in controller: WalletCreatedController) {
        done(for: wallet)
    }
}
extension WalletCoordinator: ImportMainWalletViewControllerDelegate {
    func didImportWallet(wallet: WalletInfo, in controller: ImportMainWalletViewController) {
        markAsMainWallet(for: wallet, walletName: nil)
        showConfirm(for: wallet, type: .imported, completedBackup: true)
    }

    func didSkipImport(in controller: ImportMainWalletViewController) {
        pushSelectCoin()
    }
}

extension WalletCoordinator: SelectCoinViewControllerDelegate {
    func didSelect(coin: Coin, in controller: SelectCoinViewController) {
        pushImportWalletView(for: coin)
    }
}

extension WalletCoordinator: ImportNewMainWalletViewControllerDelegate {
    func didImportAccount(account: WalletInfo, fields: [WalletInfoField], in viewController: ImportNewMainWalletViewController, password: String) {
        keystore.store(object: account.info, fields: fields)
//        func setPassword(_ password: String, for account: Wallet) -> Bool
        keystore.setPassword(password, for: account.currentWallet!)
        self.savePassWord(address: account.address.description, pwd: password)
        print("address", account.address.description, "\n password", password)
        done(for: account)
//        walletCreated(wallet: account, type: .imported)
    }
}
extension WalletCoordinator: MLCreateWalletViewControllerDelegate {
    func didPressCreateWallet(in viewController: MLCreateWalletViewController, createWalletViewModel: CreateWalletViewModel) {
        createInstantWallet(createWalletViewModel: createWalletViewModel)
    }
    func didPressImportWallet(in viewController: MLCreateWalletViewController) {
        pushImportWallet()
    }
}

extension WalletCoordinator: MLWalletPasswordViewControllerDelegate {
//    func sureAction(viewController: MLWalletPasswordViewController) {
//        didFinishVerifyPassword(vc: viewController)
//    }
    func dismissAction(viewController: MLWalletPasswordViewController) {
        dismissVerifyPassword(vc: viewController)
    }
}
