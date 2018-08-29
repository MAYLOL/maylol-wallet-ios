// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class UnderLineTextFiled: UITextField {
    var underLineColor: UIColor

    public override init(frame: CGRect) {
        underLineColor = Colors.textgraycolor
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let content = UIGraphicsGetCurrentContext()!
        content.setFillColor(underLineColor.cgColor)
        content.fill(CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
    }
}
