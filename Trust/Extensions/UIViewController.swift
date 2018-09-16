// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import Result
import MBProgressHUD
import SafariServices

enum ConfirmationError: LocalizedError {
    case cancel
}

extension UIViewController {

    func addRightMenuListBtn() -> UIButton {
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(R.image.ml_wallet_home_btnmenu(), for: UIControlState())
        rightBtn.addTarget(self, action: #selector(showMenuList), for: UIControlEvents.touchUpInside)
        return rightBtn
    }

    @objc func showMenuList() {
    }

    func displayError(error: Error) {
        let alertController = UIAlertController(title: error.prettyError, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(), style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func confirm(
        title: String? = .none,
        message: String? = .none,
        okTitle: String = R.string.localizable.oK(),
        okStyle: UIAlertActionStyle = .default,
        completion: @escaping (Result<Void, ConfirmationError>) -> Void
        ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: okTitle, style: okStyle, handler: { _ in
            completion(.success(()))
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            completion(.failure(ConfirmationError.cancel))
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    func confirmPassWord(
        title: String? = .none,
        message: String? = .none,
        okTitle: String = "ML.Sure".localized(),
        okStyle: UIAlertActionStyle = .default,
        address: String,
        completion: @escaping (Result<Void, ConfirmationError>) -> Void
        ) {
        let alertController = UIAlertController(title: "ML.lock.enter.passcode.view.model.initial".localized(), message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: okTitle, style: okStyle, handler: { _ in
            let passWordField = alertController.textFields?.first
            guard MLKeychain().verify(passworld: (passWordField?.text)!, service: address) else {
                MLProgressHud.showError(error: MLErrorType.PasswordError as NSError)
                return
            }
            completion(.success(()))
        }))
        alertController.addAction(UIAlertAction(title: "ML.Cancel".localized(), style: .cancel, handler: { _ in
            completion(.failure(ConfirmationError.cancel))
        }))
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "ML.Password".localized()
            field.isSecureTextEntry = true
        }
        self.present(alertController, animated: true, completion: nil)
    }

    func displayLoading(
        text: String = String(format: NSLocalizedString("loading.dots", value: "Loading %@", comment: ""), "..."),
        animated: Bool = true
        ) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: animated)
        hud.label.text = text
    }

    func hideLoading(animated: Bool = true) {
        MBProgressHUD.hide(for: view, animated: animated)
    }

    func openURL(_ url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = Colors.darkBlue
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true, completion: nil)
    }

    func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }

    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    func showShareActivity(from sender: UIView, with items: [Any], completion: (() -> Swift.Void)? = nil) {
        let activityViewController = UIActivityViewController.make(items: items)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.centerRect
        present(activityViewController, animated: true, completion: completion)
    }
}
