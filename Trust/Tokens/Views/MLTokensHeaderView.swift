// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLTokensHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        //            AppStyle.PingFangSC30.font
        return titleLabel
    }()
    lazy var addressLabel: UILabel = {
       let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        //        let str = NSLocalizedString("ML.Manager.tokens.noWallet", value: "你还没有钱包", comment: "")
        addressLabel.textAlignment = .left
        addressLabel.textColor = Colors.titleBlackcolor
        addressLabel.font = AppStyle.PingFangSC12.font
addressLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return addressLabel
    }()
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.image = R.image.ml_wallet_home_icon_code()
        return iconView
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.layer.cornerRadius = 2
        underDynamicLine.layer.masksToBounds = true
        underDynamicLine.backgroundColor = Colors.f02e44color
        return underDynamicLine
    }()

    lazy var amountLabel: UILabel = {
        var amountLabel: UILabel
        amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        //        let str = NSLocalizedString("ML.Tokens.cell.Totalassets", value: "TotalAssets", comment: "")
        //        subDetailTitleLabel.text = str
        amountLabel.textAlignment = .center
        amountLabel.textColor = Colors.detailTextgraycolor
        amountLabel.numberOfLines = 4
        amountLabel.font = AppStyle.PingFangSC15.font
        return amountLabel
    }()

    var viewModel: TokensViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            titleLabel.text = viewModel?.session.account.info.name
//            print(viewModel?.session.account.address.description ?? ""); addressBtn.setTitle(viewModel?.session.account.address.description, for: .normal)
            addressLabel.text = viewModel?.session.account.address.description
            amountLabel.attributedText = viewModel?.headerAttributeBalance
            amountLabel.textColor = viewModel?.headerBalanceTextColor
            amountLabel.font = viewModel?.headerBalanceFont

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(iconView)
        addSubview(underDynamicLine)
        addSubview(amountLabel)

        let addressframe: CGRect = sizeWithText(text: "0x000000000000000000000000000000000000003c", font: AppStyle.PingFangSC12.font, size: CGSize.init(width: 300, height: 20))
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            //            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: kStatusBarHeight + 85),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            addressLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            addressLabel.widthAnchor.constraint(equalToConstant: 200),
            addressLabel.heightAnchor.constraint(equalToConstant: addressframe.height),
            iconView.leftAnchor.constraint(equalTo: addressLabel.rightAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor, constant: 0),
            underDynamicLine.leftAnchor.constraint(equalTo: addressLabel.leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 53),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            amountLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor, constant: 0),
            amountLabel.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 33),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
