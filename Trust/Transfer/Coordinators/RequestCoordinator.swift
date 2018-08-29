// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol RequestCoordinatorDelegate: class {
    func popCoordinator(coordinator: RequestCoordinator)
}

final class RequestCoordinator: RootCoordinator {
    let session: WalletSession
    var coordinators: [Coordinator] = []

    weak var delegate: RequestCoordinatorDelegate?
    var rootViewController: UIViewController {
        return controller
    }

    private lazy var controller: UIViewController = {
        let controller = RequestViewController(viewModel: viewModel)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        controller.hidesBottomBarWhenPushed = true
        return controller
    }()
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_error(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        delegate?.popCoordinator(coordinator: self)
    }

    lazy var shareBarButtonitem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
    }()
    private lazy var viewModel: RequestViewModel = {
        return RequestViewModel(coinTypeViewModel: coinTypeViewModel)
    }()
    private let coinTypeViewModel: CoinTypeViewModel

    init(
        session: WalletSession,
        coinTypeViewModel: CoinTypeViewModel
    ) {
        self.session = session
        self.coinTypeViewModel = coinTypeViewModel
    }

    @objc func share(_ sender: UIBarButtonItem) {
        let items = [viewModel.shareMyAddressText, (rootViewController as? RequestViewController)?.imageView.image as Any].compactMap { $0 }
        let activityViewController = UIActivityViewController.make(items: items)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}
