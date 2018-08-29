// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLWalletSettingCell: UITableViewCell {
    static let identifier = "MLWalletSettingCell"
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
        return iconView
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.backgroundColor = Colors.e6e6e6color
        return underDynamicLine
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        //            UITableViewCellSelectionStyleNone
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(underDynamicLine)
    }

    var settingModel: MLWalletSettingModel? {
        didSet {  
            titleLabel.text = settingModel?.settingText
            iconView.image = settingModel?.settingIcon
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10),
            underDynamicLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            underDynamicLine.leftAnchor.constraint(equalTo: iconView.leftAnchor, constant: 0),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 149),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
