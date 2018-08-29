// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class PassphraseBackgroundShadow: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = Colors.e6e6e6color
        layer.cornerRadius = 10
        layer.masksToBounds = true
//        let borderColor = Colors.e6e6e6color
//        let height: CGFloat = 0


//        let topSeparator: UIView = .spacer(height: height, backgroundColor: borderColor, alpha: 0.3)
//        let bottomSeparator: UIView = .spacer(height: height, backgroundColor: borderColor, alpha: 0.3)
//
//        addSubview(topSeparator)
//        addSubview(bottomSeparator)

//        NSLayoutConstraint.activate([
//            topSeparator.topAnchor.constraint(equalTo: topAnchor),
//            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
//            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -height),
//            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
//            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
//        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
