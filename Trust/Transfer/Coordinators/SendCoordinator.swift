// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt
import TrustCore
import TrustKeystore
import Result

protocol SendCoordinatorDelegate: class {
    func didFinish(_ result: Result<ConfirmResult, AnyError>, in coordinator: SendCoordinator)
    func didDismiss(coordinator: SendCoordinator)
}

final class SendCoordinator: RootCoordinator {
    let transfer: Transfer
    let session: WalletSession
    let account: Account
    let navigationController: NavigationController
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    weak var delegate: SendCoordinatorDelegate?
    var rootViewController: UIViewController {
        return controller
    }

    private lazy var controller: MLSendViewController = {
        let controller = MLSendViewController(
            session: session,
            storage: session.tokensStorage,
            account: account,
            transfer: transfer,
            chainState: chainState
        )
        //        controller.navigationItem.backBarButtonItem = nil
        controller.hidesBottomBarWhenPushed = true
        //        switch transfer.type {
        //        case .ether(_, let destination):
        //            controller.addressRow?.value = destination?.description
        //            controller.addressRow?.cell.row.updateCell()
        //        case .token, .dapp: break
        //        }
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        controller.delegate = self
        return controller
    }()
    lazy var chainState: ChainState = {
        let state = ChainState(server: transfer.server)
        state.fetch()
        return state
    }()
    init(
        transfer: Transfer,
        navigationController: NavigationController = NavigationController(),
        session: WalletSession,
        keystore: Keystore,
        account: Account
        ) {
        self.transfer = transfer
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.account = account
        self.keystore = keystore
    }
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        delegate?.didDismiss(coordinator: self)
    }

    func presentQRCodeReader() {
        let coordinator = ScanQRCodeCoordinator(
            navigationController: NavigationController()
        )
        coordinator.delegate = self
        addCoordinator(coordinator)
        navigationController.present(coordinator.qrcodeController, animated: true, completion: nil)
    }
}

extension SendCoordinator: MLSendViewControllerDelegate {

    func didPressConfirm(transaction: UnconfirmedTransaction, transfer: Transfer, in viewController: MLSendViewController) {
        let configurator = TransactionConfigurator(
            session: session,
            account: account,
            transaction: transaction,
            server: transfer.server,
            chainState: ChainState(server: transfer.server)
        )

        let coordinator = ConfirmCoordinator(
            navigationController: navigationController,
            session: session,
            configurator: configurator,
            keystore: keystore,
            account: account,
            type: .signThenSend,
            server: transfer.server
        )
        coordinator.didCompleted = { [weak self] result in
            guard let `self` = self else { return }
            self.delegate?.didFinish(result, in: self)
        }
        coordinator.startConfirm(nav: navigationController)
        addCoordinator(coordinator)
    }

    func didPressScan() {
        presentQRCodeReader()
    }
}

extension SendCoordinator: ScanQRCodeCoordinatorDelegate {
    func didCancel(in coordinator: ScanQRCodeCoordinator) {
        coordinator.navigationController.dismiss(animated: true, completion: nil)
        removeCoordinator(coordinator)
    }

    func didScan(result: String, in coordinator: ScanQRCodeCoordinator) {
        coordinator.navigationController.dismiss(animated: true, completion: nil)
        removeCoordinator(coordinator)
        guard let url = URL(string: result) else {
            return
        }
//        controller.
    }
}
//extension SendCoordinator: ConfirmCoordinatorDelegate {
//    func didCancel(in coordinator: ConfirmCoordinator) {
//        coordinator.endConfirm {
//        }
//    }
//}
