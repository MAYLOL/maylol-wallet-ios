// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import MBProgressHUD

class MLProgressHud {

    enum status {
        case Success
        case Error
        case Info
    }

    class func show(view: UIView, status: status, state: String) {
//        switch status {
//        case .Success.Error.Info:
            showHud(view: view, status: status, state: state)
//        case
//            showHud(view: view, status: status, state: state)
//        case
//            showHud(view: view, status: status, state: state)
//        }
    }
    private class func showHud(view:UIView,status: status, state: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: false)
        hud.label.text = state
        hud.mode = .text
        hud.hide(animated: false, afterDelay: 1.5)
    }

   class func showError(error: NSError) {
        let hud = MBProgressHUD.showAdded(to: ShareAppDelegate.window!, animated: false)
        hud.label.text = error.localizedDescription
        hud.mode = .text
        hud.hide(animated: false, afterDelay: 1.5)
    }
}
