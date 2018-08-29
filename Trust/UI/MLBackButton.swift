// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLBackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(R.image.ml_wallet_btn_return(), for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let iconW: CGFloat = 11
        let iconH: CGFloat = 17.5
        let iconX: CGFloat = 22
        let iconY: CGFloat = 33
        return CGRect.init(x: iconX, y: iconY, width: iconW, height: iconH)
    }

}
