// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import UIKit

protocol InitialWalletCreationCoordinatorDelegate: class {
    func didCancel(in coordinator: InitialWalletCreationCoordinator)
    func didAddAccount(_ account: WalletInfo, in coordinator: InitialWalletCreationCoordinator)
}

final class InitialWalletCreationCoordinator: Coordinator {

    let navigationController: NavigationController
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    weak var delegate: InitialWalletCreationCoordinatorDelegate?
    let entryPoint: WalletEntryPoint

    private var createWalletViewModel: CreateWalletViewModel = CreateWalletViewModel(title: "", password: "")

    init(
        navigationController: NavigationController = NavigationController(),
        keystore: Keystore,
        entryPoint: WalletEntryPoint
        ) {
        self.navigationController = navigationController
        self.keystore = keystore
        self.entryPoint = entryPoint
    }

    func start() {
        switch entryPoint {
        case .welcome:
            showCreateWallet()
        case .createInstantWallet:
            presentCreateWallet()
        case .importWallet:
            presentImportWallet()
        }
    }

    func setCreateWallet(createWalletViewModel: CreateWalletViewModel) {
        self.createWalletViewModel = createWalletViewModel
    }

    func showCreateWallet() {
        let coordinator = WalletCoordinator(navigationController: navigationController, keystore: keystore)
        coordinator.delegate = self
        coordinator.setCreateWallet(createWalletViewModel: self.createWalletViewModel)
        coordinator.start(.createInstantWallet)
        addCoordinator(coordinator)
    }
    func presentCreateWallet() {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.delegate = self
        coordinator.start(.createInstantWallet)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
        addCoordinator(coordinator)
    }

    func presentImportWallet() {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.delegate = self
        coordinator.start(.importWallet)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
        addCoordinator(coordinator)
    }
}

extension InitialWalletCreationCoordinator: WalletCoordinatorDelegate {
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator) {
        delegate?.didAddAccount(account, in: self)
        removeCoordinator(coordinator)
    }

    func didCancel(in coordinator: WalletCoordinator) {
        delegate?.didCancel(in: self)
        removeCoordinator(coordinator)
    }
}
