// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
protocol MLScreenCaptureViewDelegate: class {
    func yeeAction()
}

class MLScreenCaptureView: UIView {

    weak var delegate: MLScreenCaptureViewDelegate?

    lazy var fullView: UIView = {
        let fullView = UIView()
        fullView.translatesAutoresizingMaskIntoConstraints = false
        fullView.alpha = 0.5
        fullView.backgroundColor = UIColor.black
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        var effecview = UIVisualEffectView(effect: blur)
//        effecview.alpha = 0.5
//        effecview.translatesAutoresizingMaskIntoConstraints = false
//        effecview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        return effecview
        return fullView
    }()
    lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    lazy var iconView: UIImageView = {
        var iconView = UIImageView(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = R.image.ml_wallet_No_Canema()
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
        yeeBtn.setTitle("我知道了", for: UIControlState.normal)
        yeeBtn.titleLabel?.font = AppStyle.PingFangSC14.font
        yeeBtn.titleLabel?.textColor = UIColor.white
        yeeBtn.translatesAutoresizingMaskIntoConstraints = false
        yeeBtn.addTarget(self, action: #selector(yeeAction(sender:)), for: .touchUpInside)
        return yeeBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            fullView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            fullView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            fullView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            fullView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            alertView.centerXAnchor.constraint(equalTo: fullView.centerXAnchor, constant: 0),
            alertView.centerYAnchor.constraint(equalTo: fullView.centerYAnchor, constant: 0),
            alertView.heightAnchor.constraint(equalToConstant: 204),
            alertView.widthAnchor.constraint(equalToConstant: 250),
            iconView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 19),
            iconView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
//            iconView.widthAnchor.constraint(equalToConstant: 40),
//            iconView.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            detailLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
            detailLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 31),
            detailLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -31),
//            detailLabel.widthAnchor.constraint(equalToConstant: 80),
//            detailLabel.heightAnchor.constraint(equalToConstant: 50),
            yeeBtn.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0),
            yeeBtn.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0),
            yeeBtn.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0),
            yeeBtn.heightAnchor.constraint(equalToConstant: 44),
            ])
    }
    func setup() {
        addSubview(fullView)
        addSubview(alertView)
        alertView.addSubview(iconView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(detailLabel)
        alertView.addSubview(yeeBtn)
    }

    @objc func yeeAction(sender: UIButton) {
        isHidden = true
        delegate?.yeeAction()
    }

}
