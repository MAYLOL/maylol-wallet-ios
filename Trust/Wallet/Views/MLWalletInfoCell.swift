// Copyright DApps Platform Inc. All rights reserved.

import Foundation

class MLWalletInfoCell: UITableViewCell {
    static let identifier = "MLWalletInfoCell"
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.f646464color
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.font = AppStyle.PingFangSC12.font
        return titleLabel
    }()
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.image = R.image.ml_wallet_arrow()
        return iconView
    }()
//    lazy var underDynamicLine: UIView = {
//        var underDynamicLine = UIView()
//        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
//        underDynamicLine.backgroundColor = Colors.e6e6e6color
//        return underDynamicLine
//    }()
//    lazy var topDynamicLine: UIView = {
//        var topDynamicLine = UIView()
//        topDynamicLine.translatesAutoresizingMaskIntoConstraints = false
//        topDynamicLine.backgroundColor = Colors.e6e6e6color
//        return topDynamicLine
//    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        addSubview(titleLabel)
        addSubview(iconView)
//        addSubview(underDynamicLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
//            underDynamicLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//            underDynamicLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
//            underDynamicLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
//            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            iconView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}






