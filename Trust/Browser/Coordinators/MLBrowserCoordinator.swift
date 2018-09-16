// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt
import TrustKeystore
import RealmSwift
import URLNavigator
import WebKit
import Branch

protocol MLBrowserCoordinatorDelegate: class {
    func didCancel(in coordinator: MLBrowserCoordinator)
}
//Coordinator
final class MLBrowserCoordinator: NSObject, RootCoordinator {
    lazy var rootViewController: UIViewController = {
        return browserViewController
    }()

    weak var delegate: MLBrowserCoordinatorDelegate?

    var coordinators: [Coordinator] = []
    let navigationController: NavigationController

    lazy var browserViewController: MLBrowserViewController = {
        let controller = MLBrowserViewController(navigationController:navigationController)
        controller.webView.uiDelegate = self
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        return controller
    }()
    lazy var preferences: PreferencesController = {
        return PreferencesController()
    }()
    init(
        navigationController: NavigationController = NavigationController()
        ) {
        self.navigationController = navigationController
//        navigationController.title = ""
//        self.rootViewController = browserViewController
//        self.navigationController = NavigationController(navigationBarClass: BrowserNavigationBar.self, toolbarClass: nil)
    }

//    func start() {
//        navigationController.viewControllers = [browserViewController]
//        browserViewController.goHome()
//    }

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

    @objc func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }

    func openURL(_ url: URL) {
        returnTitle(url: url)
        navigationController.viewControllers = [rootViewController]
        browserViewController.goTo(url: url)
    }
    func returnTitle(url: URL) {
        if url.absoluteString == advanceTransferUrlStr{
            //            self.navigationController.title =
            browserViewController.navigationItem.title = "ML.Transaction.cell.HowToSetParameters".localized()
        }
        if url.absoluteString == backupsPurseUrlStr {
            browserViewController.navigationItem.title = "ML.export.backup.button.Howtotitle".localized()
        }
        if url.absoluteString == gasPriseUrlStr {
            browserViewController.navigationItem.title = "什么是矿工费"
        }
        if url.absoluteString == memoryWordsUrlStr {
            browserViewController.navigationItem.title = "什么是助记词"
        }
        if url.absoluteString == privacyClauseUrlStr {
            browserViewController.navigationItem.title = "ML.Setting.cell.Aboutus.PrivacyClause".localized()
        }
        if url.absoluteString == privateKeyUrlStr {
            browserViewController.navigationItem.title = "什么是明文私钥"
        }
        if url.absoluteString == serviceAgreementUrlStr {
            browserViewController.navigationItem.title = "ML.Setting.cell.Aboutus.ProductGuide".localized()
        }
        if url.absoluteString == useProtocolUrlStr {
            browserViewController.navigationItem.title = "ML.Setting.cell.Aboutus.UseProtocol".localized()
        }
    }
}

extension MLBrowserCoordinator: SignMessageCoordinatorDelegate {
    func didCancel(in coordinator: SignMessageCoordinator) {
        coordinator.didComplete = nil
        removeCoordinator(coordinator)
    }
}

extension MLBrowserCoordinator: ConfirmCoordinatorDelegate {
    func didCancel(in coordinator: ConfirmCoordinator) {
        navigationController.dismiss(animated: true, completion: nil)
        coordinator.didCompleted = nil
        removeCoordinator(coordinator)
    }
}

extension MLBrowserCoordinator: ScanQRCodeCoordinatorDelegate {
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
        openURL(url)
    }
}

extension MLBrowserCoordinator: BookmarkViewControllerDelegate {
    func didSelectBookmark(_ bookmark: Bookmark, in viewController: BookmarkViewController) {
        guard let url = bookmark.linkURL else {
            return
        }
        openURL(url)
    }
}

extension MLBrowserCoordinator: HistoryViewControllerDelegate {
    func didSelect(history: History, in controller: HistoryViewController) {
        guard let url = history.URL else {
            return
        }
        openURL(url)
    }
}

extension MLBrowserCoordinator: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        navigationController.title = webView.title
        if navigationAction.targetFrame == nil {
            browserViewController.webView.load(navigationAction.request)
        }
        return nil
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: message,
            style: .alert,
            in: navigationController
        )
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default, handler: { _ in
            completionHandler()
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: message,
            style: .alert,
            in: navigationController
        )
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .default, handler: { _ in
            completionHandler(false)
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: prompt,
            style: .alert,
            in: navigationController
        )
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .default, handler: { _ in
            completionHandler(nil)
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
