// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLConfirmInfoLabel: UIView {

    enum style {
        case style1
        case style2
    }

    lazy var leftLabel: UILabel = {
        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.textColor = Colors.detailTextgraycolor
        leftLabel.textAlignment = NSTextAlignment.left
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        return leftLabel
    }()

    lazy var rightLabel: UILabel = {
        let rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.textColor = Colors.titleBlackcolor
        rightLabel.font = UIFont.systemFont(ofSize: 12)
        rightLabel.textAlignment = NSTextAlignment.left
        rightLabel.numberOfLines = 2
        return rightLabel
    }()

    lazy var rightLabel2: UILabel = {
        let rightLabel2 = UILabel()
        rightLabel2.translatesAutoresizingMaskIntoConstraints = false
        rightLabel2.textColor = Colors.detailTextgraycolor
        rightLabel2.font = UIFont.systemFont(ofSize: 10)
        rightLabel2.textAlignment = NSTextAlignment.right
        rightLabel2.numberOfLines = 2
        return rightLabel2
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            rightLabel,
            rightLabel2,]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    var style: style? {
        didSet {
            switch self.style {
            case .style1?:
                style1()
            case .style2?:
                style2()
            case .none:
                style1()
            }
        }
    }

    var underLineColor: UIColor

    public override init(frame: CGRect) {
        underLineColor = Colors.textgraycolor
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    func style1() {
    addSubview(leftLabel)
    addSubview(rightLabel)
    NSLayoutConstraint.activate([
    leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
    leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
    rightLabel.leftAnchor.constraint(equalTo: leftLabel.rightAnchor, constant: 27),
    rightLabel.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor, constant: 0),
    rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
    ])
    }

    func style2() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leftAnchor.constraint(equalTo: leftLabel.rightAnchor, constant: 27),
            stackView.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

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
