// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

class MLWalletInfoHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return titleLabel
    }()
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.isUserInteractionEnabled = true
        addressLabel.textAlignment = .left
        addressLabel.textColor = Colors.detailTextgraycolor
        addressLabel.font = AppStyle.PingFangSC11.font
        addressLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return addressLabel
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.layer.cornerRadius = 2
        underDynamicLine.layer.masksToBounds = true
        underDynamicLine.backgroundColor = Colors.f02e44color
        return underDynamicLine
    }()
    var viewModel: MLWalletInfoViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            titleLabel.text = viewModel?.balanceStr
            addressLabel.text = viewModel?.address
        }
    }
//    var viewModel: TokensViewModel? {
//        didSet {
//            guard viewModel != nil else {
//                return
//            }
//            titleLabel.text = viewModel?.session.account.info.name
//            addressLabel.text = viewModel?.session.account.address.description
//
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(underDynamicLine)

        let addressframe: CGRect = sizeWithText(text: "0x000000000000000000000000000000000000003c", font: AppStyle.PingFangSC12.font, size: CGSize.init(width: 300, height: 20))
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            addressLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            addressLabel.widthAnchor.constraint(equalToConstant: 200),
            addressLabel.heightAnchor.constraint(equalToConstant: addressframe.height),
            underDynamicLine.leftAnchor.constraint(equalTo: addressLabel.leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 53),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
