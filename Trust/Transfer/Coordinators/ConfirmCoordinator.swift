// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import TrustCore
import TrustKeystore
import Result

protocol ConfirmCoordinatorDelegate: class {
    func didCancel(in coordinator: ConfirmCoordinator)
}

final class ConfirmCoordinator: RootCoordinator {
    let navigationController: NavigationController
    let session: WalletSession
    let account: Account
    let keystore: Keystore
    let configurator: TransactionConfigurator
    var didCompleted: ((Result<ConfirmResult, AnyError>) -> Void)?
    let type: ConfirmType
    let server: RPCServer

    var coordinators: [Coordinator] = []
    weak var delegate: ConfirmCoordinatorDelegate?

    var rootViewController: UIViewController {
        return controller
    }
    private lazy var controller: MLConfirmPaymentViewController = {
        let controller = MLConfirmPaymentViewController(
            session: session,
            keystore: keystore,
            configurator: configurator,
            confirmType: type,
            server: server
        )
        controller.delegate = self
        return controller
    }()
//    private lazy var controller: MLConfirmPaymentViewController = {
//        var controller = MLConfirmPaymentViewController()
//        controller.delegate = self
//        return controller
//    }()
    init(
        navigationController: NavigationController = NavigationController(),
        session: WalletSession,
        configurator: TransactionConfigurator,
        keystore: Keystore,
        account: Account,
        type: ConfirmType,
        server: RPCServer
    ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.configurator = configurator
        self.keystore = keystore
        self.account = account
        self.type = type
        self.server = server
//        navigationController.viewControllers = [controller]
        controller.didCompleted = { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.endConfirm {
                    [weak self] in
                    //取消
//                    self.didCompleted?(.failure(AnyError(DAppError.cancelled)))
                    self?.didCompleted?(.success(data))
                    self?.delegate?.didCancel(in: self!)
                }
//                self.didCompleted?(.success(data))
            case .failure(let error):
                self.endConfirm {
                    [weak self] in
                    //取消
                    self?.didCompleted?(.failure(error))
                    self?.delegate?.didCancel(in: self!)
                }
            }
        }
    }

    func pushVerifyPWD(completeHandle closure:@escaping ()->()) {
        let coordinator = WalletCoordinator(keystore: keystore)
        coordinator.verifyPasswordVC(nav: self.navigationController, session: session, completeHandle: closure)
        addCoordinator(coordinator)
    }

    func startConfirm(nav: NavigationController) {
//        nav.addChildViewController(controller)
        nav.view.addSubview(controller.view)
        controller.start()
    }

    func endConfirm(closure:@escaping ()->()) {
        controller.view.removeFromSuperview()
        controller.end(closure: closure)
    }

    func start() {
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
        navigationController.viewControllers = [controller]
    }
    @objc func dismiss() {
        didCompleted?(.failure(AnyError(DAppError.cancelled)))
        delegate?.didCancel(in: self)
    }
}

extension ConfirmCoordinator: MLConfirmPaymentViewControllerDelegate {
//    func sureAction(viewController: MLConfirmPaymentViewController) {
//        //确认信息之后跳转密码
//        pushVerifyPWD(completeHandle: {
//            didCompleted?(.success("success",nil))
//        })
//    }

    func dismissAction(viewController: MLConfirmPaymentViewController) {
        endConfirm {
            //取消
            self.didCompleted?(.failure(AnyError(DAppError.cancelled)))
            self.delegate?.didCancel(in: self)
        }
    }
}
