// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol MLManageWalletViewCellDelegate: class {
    func didPress(viewModel: WalletAccountViewModel, in cell: MLManageWalletViewCell)
}

class MLManageWalletViewCell: UITableViewCell {
    static let identifier = "MLManageWalletViewCell"

    weak var delegate: MLManageWalletViewCellDelegate?

    lazy var backView: UIView = {
        var backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = Colors.f2f2f2color
        backView.layer.cornerRadius = 10
        backView.backgroundColor = Colors.f2f2f2color
        backView.layer.masksToBounds = true
        return backView
    }()

    lazy var walletNameLabel: UILabel = {
        let walletNameLabel = UILabel()
        walletNameLabel.translatesAutoresizingMaskIntoConstraints = false
        walletNameLabel.textColor = Colors.f151515color
        walletNameLabel.textAlignment = .left
        walletNameLabel.numberOfLines = 1
        walletNameLabel.font = AppStyle.PingFangSC13.font
        return walletNameLabel
    }()
    lazy var backupsBtn: UIButton = {
        let backupsBtn = UIButton(type: UIButtonType.custom)
        backupsBtn.translatesAutoresizingMaskIntoConstraints = false
        backupsBtn.setTitle("ML.BackupWallet.Please".localized(), for: UIControlState.normal)
        backupsBtn.setTitleColor(Colors.bf2537color, for: UIControlState.normal)
        backupsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        backupsBtn.isHidden = false
        backupsBtn.layer.cornerRadius = 4
        backupsBtn.layer.masksToBounds = true
        backupsBtn.layer.borderColor = Colors.bf2537color.cgColor
        backupsBtn.layer.borderWidth = 1
        return backupsBtn
    }()
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        //        let str = NSLocalizedString("ML.Manager.tokens.noWallet", value: "你还没有钱包", comment: "")
        addressLabel.isUserInteractionEnabled = true
        addressLabel.textAlignment = .left
        addressLabel.textColor = Colors.f4a4a4acolor
        addressLabel.font = AppStyle.PingFangSC13.font
        addressLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return addressLabel
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
        underDynamicLine.backgroundColor = Colors.ccccccolor
        return underDynamicLine
    }()
    lazy var ethFreeCountLabel: UILabel = {
        let ethFreeCountLabel = UILabel()
        ethFreeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        ethFreeCountLabel.isUserInteractionEnabled = true
        ethFreeCountLabel.textAlignment = .right
        ethFreeCountLabel.attributedText = getEthFreeCount(ethFree: "0")
        ethFreeCountLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return ethFreeCountLabel
    }()
    var viewModel: WalletAccountViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            walletNameLabel.text = viewModel?.title
            backupsBtn.isHidden = (viewModel?.wallet.info.completedBackup)!
            addressLabel.text = viewModel?.wallet.address.description

//            let ethfreeBigInt = EtherNumberFormatter.full.number(from: viewModel?.wallet.info.balance ?? "0", units: EthereumUnit.wei)!
//            let ethfreeStr = EtherNumberFormatter.short.string(from: ethfreeBigInt, units: .ether)
//            ethFreeCountLabel.attributedText = getEthFreeCount(ethFree: ethfreeStr)
            ethFreeCountLabel.attributedText = getEthFreeCount(ethFree: (viewModel?.balanceStr)!)
        }
    }
//    var amount: String {
//        return shortFormatter.string(from: BigInt(viewModel.token.value) ?? BigInt(), decimals: viewModel.token.decimals)
//    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none

        addSubview(backView)
        backView.addSubview(walletNameLabel)
        backView.addSubview(backupsBtn)
        backView.addSubview(addressLabel)
        backView.addSubview(iconView)
        backView.addSubview(underDynamicLine)
        backView.addSubview(ethFreeCountLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            backView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            backView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(115)),
            walletNameLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 14),
            walletNameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: kAutoLayoutHeigth(17)),
            backupsBtn.leftAnchor.constraint(equalTo: walletNameLabel.rightAnchor, constant: 15),
            backupsBtn.widthAnchor.constraint(equalToConstant: 50),
            backupsBtn.heightAnchor.constraint(equalToConstant: 15),
            backupsBtn.centerYAnchor.constraint(equalTo: walletNameLabel.centerYAnchor, constant: 0),
            addressLabel.topAnchor.constraint(equalTo: backupsBtn.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            addressLabel.leftAnchor.constraint(equalTo: walletNameLabel.leftAnchor, constant: 0),
            addressLabel.widthAnchor.constraint(equalToConstant: 200),
            iconView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -14),
            iconView.topAnchor.constraint(equalTo: backView.topAnchor, constant: kAutoLayoutHeigth(31)),
            underDynamicLine.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: kAutoLayoutHeigth(15)),
            underDynamicLine.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 14),
            underDynamicLine.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -14),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            ethFreeCountLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -25),
            ethFreeCountLabel.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            ])
    }
    private func getEthFreeCount(ethFree: String) -> NSAttributedString {
        let ethFreeStr = ethFree
        let company = " ether"
        let attstr = NSMutableAttributedString(string: ethFreeStr)
        attstr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.strokeColor: Colors.f323232color], range: NSRange(location: 0, length: ethFreeStr.length))
        let attstr2 = NSMutableAttributedString(string: company)
        attstr2.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.strokeColor: Colors.f979797color], range: NSRange(location: 0, length: company.length))
        attstr.append(attstr2)
        return attstr
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
}
