// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLTransactionSessionView: UIView {

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = NSLocalizedString("ML.Transaction.Recentrecords", value: "Recent Transaction Records", comment: "")
        return titleLabel
    }()
        lazy var grayLine: UIView = {
            var grayLine = UIView()
            grayLine.translatesAutoresizingMaskIntoConstraints = false
            grayLine.backgroundColor = Colors.e6e6e6color
            return grayLine
        }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(grayLine)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            grayLine.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            grayLine.rightAnchor.constraint(equalTo: rightAnchor, constant: kAutoLayoutWidth(25)),
            grayLine.leftAnchor.constraint(equalTo: leftAnchor, constant: kAutoLayoutWidth(25)),
            grayLine.heightAnchor.constraint(equalToConstant: 1),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: kAutoLayoutWidth(25)),
            titleLabel.topAnchor.constraint(equalTo: grayLine.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

