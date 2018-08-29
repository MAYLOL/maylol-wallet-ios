// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
protocol MLScreenCaptureViewDelegate: class {
    func yeeAction()
}

class MLScreenCaptureView: UIView {

    weak var delegate: MLScreenCaptureViewDelegate?
    lazy var iconView: UIImageView = {
        var iconView = UIImageView(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = R.image.ml_wallet_btn_error()
        return iconView
    }()
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel(frame: .zero)
        titleLabel.font = AppStyle.PingFangSC15.font
        titleLabel.textColor = AppStyle.PingFangSC15.textColor
        titleLabel.text = "请勿截图"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel(frame: .zero)
        detailLabel.font = AppStyle.PingFangSC11.font
        detailLabel.textColor = AppStyle.PingFangSC11.textColor
        detailLabel.text = "如果有人获取了你的助记词将直接获取你的资产！请抄下助记词并存放在安全的地方"
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.numberOfLines = 0
        return detailLabel
    }()
    lazy var yeeBtn: UIButton = {
        var yeeBtn = UIButton(type: UIButtonType.custom)
        yeeBtn.backgroundColor = Colors.f02e44color
        yeeBtn.titleLabel?.text = "我知道了"
        yeeBtn.titleLabel?.font = AppStyle.PingFangSC14.font
        yeeBtn.titleLabel?.textColor = UIColor.white
        yeeBtn.translatesAutoresizingMaskIntoConstraints = false
        yeeBtn.addTarget(self, action: #selector(yeeAction(sender:)), for: .touchUpInside)
        return yeeBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        NSLayoutConstraint.activate([
//            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 19),
//            iconView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//            iconView.widthAnchor.constraint(equalToConstant: 40),
//            iconView.heightAnchor.constraint(equalToConstant: 40),
//            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 15),
//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//            titleLabel.widthAnchor.constraint(equalToConstant: 80),
//            titleLabel.heightAnchor.constraint(equalToConstant: 30),
//            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
//            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//            detailLabel.widthAnchor.constraint(equalToConstant: 80),
//            detailLabel.heightAnchor.constraint(equalToConstant: 50),
//            yeeBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
//            yeeBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
//            yeeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//            yeeBtn.heightAnchor.constraint(equalToConstant: 44),
//            ])
    }
    func setup() {
        backgroundColor = UIColor.white
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(yeeBtn)
        iconView.frame = CGRect.init(x: 0, y: 19, width: 40, height: 40)
        iconView.center.x = self.center.x
        titleLabel.frame = CGRect.init(x: 0, y: 75, width: 80, height: 30)
        titleLabel.center.x = self.center.x
        detailLabel.frame = CGRect.init(x: 0, y: 120, width: 80, height: 60)
        detailLabel.center.x = self.center.x
        yeeBtn.frame = CGRect.init(x: 0, y: 200, width: 200, height: 30)
        yeeBtn.center.x = self.center.x

    }

    @objc func yeeAction(sender: UIButton) {
        delegate?.yeeAction()
    }

}
