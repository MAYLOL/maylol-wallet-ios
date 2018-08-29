// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLSimpleSlider: UISlider {

    lazy var selectControl: UIControl = {
        var selectControl = UIControl()
        selectControl.translatesAutoresizingMaskIntoConstraints = false
        return selectControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(selectControl)
        selectControl.frame = frame
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
