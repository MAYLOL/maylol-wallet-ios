// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLSettingViewCell: UITableViewCell {

    static let identifier = "MLSettingViewCell"
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppStyle.PingFangSC13.textColor
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.font = AppStyle.PingFangSC13.font
        return titleLabel
    }()
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.image = R.image.ml_wallet_arrow()
        return iconView
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.backgroundColor = Colors.e6e6e6color
        return underDynamicLine
    }()
    lazy var topDynamicLine: UIView = {
        var topDynamicLine = UIView()
        topDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        topDynamicLine.backgroundColor = Colors.e6e6e6color
        return topDynamicLine
    }()
    var settingModel: String? {
        didSet {
            titleLabel.text = settingModel
            if (settingModel == NSLocalizedString("ML.Setting.cell.Aboutus.UseProtocol", value: "Use Protocol", comment: "")){
                addSubview(topDynamicLine)
                NSLayoutConstraint.activate([
                    topDynamicLine.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                    topDynamicLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
                    topDynamicLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
                    topDynamicLine.heightAnchor.constraint(equalToConstant: 1),
                    ])
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(underDynamicLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            underDynamicLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            underDynamicLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            underDynamicLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            titleLabel.bottomAnchor.constraint(equalTo: underDynamicLine.topAnchor, constant: -7),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            iconView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
