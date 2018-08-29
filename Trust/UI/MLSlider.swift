// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLSlider: UISlider {

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
      let boundss = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return CGRect(x: boundss.origin.x, y: boundss.origin.y, width: 16, height: 1)
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let boundss = super.trackRect(forBounds: bounds)

        return CGRect(x: boundss.origin.x, y: bounds.origin.y, width: bounds.size.width, height: 1)
    }
}
