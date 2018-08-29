// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol MLWalletViewCellDelegate: class {
    func didPress(viewModel: WalletAccountViewModel, in cell: MLWalletViewCell)
}

class MLWalletViewCell: UITableViewCell {
    static let identifier = "MLWalletViewCell"

    weak var delegate: MLWalletViewCellDelegate?

    lazy var walletNameLabel: UILabel = {
        let walletNameLabel = UILabel()
        walletNameLabel.translatesAutoresizingMaskIntoConstraints = false
        walletNameLabel.textColor = AppStyle.PingFangSC13.textColor
        walletNameLabel.textAlignment = .left
        walletNameLabel.textColor = UIColor.black
        walletNameLabel.numberOfLines = 0
        walletNameLabel.font = AppStyle.PingFangSC13.font
        return walletNameLabel
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.layer.cornerRadius = 2
        underDynamicLine.isHidden = true
        underDynamicLine.layer.masksToBounds = true
        underDynamicLine.backgroundColor = Colors.f02e44color
        return underDynamicLine
    }()
    var viewModel: WalletAccountViewModel? {
        didSet {
            guard let model = viewModel else {
                return
            }
            walletNameLabel.text = model.title
            underDynamicLine.isHidden = !model.isSelect!
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
//            UITableViewCellSelectionStyleNone
        addSubview(walletNameLabel)
        addSubview(underDynamicLine)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            walletNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            walletNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: walletNameLabel.bottomAnchor, constant: 5),
            underDynamicLine.leftAnchor.constraint(equalTo: walletNameLabel.leftAnchor, constant: 0),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 40),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 2),
            ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
}
