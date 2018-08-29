// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol MLTokensHomeViewControllerDelegate : class {
    func didPressCreateWallet(in viewController: MLTokensHomeViewController)

    func didPressImportWallet(in viewController: MLTokensHomeViewController)
}
class MLTokensHomeViewController: UIViewController {

    weak var delegate: MLTokensHomeViewControllerDelegate?
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppStyle.PingFangSC30.textColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
//            AppStyle.PingFangSC30.font
        titleLabel.text = "MAYLOL"
        return titleLabel
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.layer.cornerRadius = 2
        underDynamicLine.layer.masksToBounds = true
        underDynamicLine.backgroundColor = Colors.f02e44color
        return underDynamicLine
    }()
    lazy var subtitleLabel: UILabel = {
        var subtitleLabel: UILabel
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let str = NSLocalizedString("ML.Manager.tokens.noWallet", value: "你还没有钱包", comment: "")
        subtitleLabel.text = str
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = Colors.titleBlackcolor
        subtitleLabel.numberOfLines = 4
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//            AppStyle.PingFangSC13.font
        return subtitleLabel
    }()
    lazy var subDetailTitleLabel: UILabel = {
        var subDetailTitleLabel: UILabel
        subDetailTitleLabel = UILabel()
        subDetailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let str = NSLocalizedString("ML.Manager.tokens.addWallet", value: "点击添加或创建钱包", comment: "")
        subDetailTitleLabel.text = str
        subDetailTitleLabel.textAlignment = .center
        subDetailTitleLabel.textColor = Colors.detailTextgraycolor
        subDetailTitleLabel.numberOfLines = 4
        subDetailTitleLabel.font = AppStyle.PingFangSC15.font



        return subDetailTitleLabel
    }()
    lazy var createBtn: UIButton = {
        let createBtn = UIButton.init(type: UIButtonType.custom)
        createBtn.translatesAutoresizingMaskIntoConstraints = false
        createBtn.backgroundColor = UIColor(hex: "F02E44")
        createBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        createBtn.setTitle(R.string.localizable.welcomeCreateWalletButtonTitle(), for: .normal)
        createBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 19)
        createBtn.layer.cornerRadius = 10
        createBtn.layer.masksToBounds = true
        createBtn.addTarget(self, action: #selector(createWalletAction(sender:)), for: .touchUpInside)
        return createBtn
    }()

    lazy var importBtn: UIButton = {
        let importBtn = UIButton.init(type: UIButtonType.custom)
        importBtn.translatesAutoresizingMaskIntoConstraints = false
        importBtn.backgroundColor = UIColor(hex: "F02E44")
        importBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        importBtn.setTitle(R.string.localizable.welcomeImportWalletButtonTitle(), for: .normal)
        importBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 19)
        importBtn.layer.cornerRadius = 10
        importBtn.layer.masksToBounds = true

        importBtn.addTarget(self, action: #selector(importWalletAction(sender:)), for: .touchUpInside)
        return importBtn
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(underDynamicLine)
        view.addSubview(subtitleLabel)
        view.addSubview(subDetailTitleLabel)
        view.addSubview(createBtn)
        view.addSubview(importBtn)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 105),
            underDynamicLine.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 54),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            subtitleLabel.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 48),
            subDetailTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            subDetailTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            createBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            createBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            createBtn.widthAnchor.constraint(equalToConstant: 175),
            createBtn.heightAnchor.constraint(equalToConstant: 40),
            importBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            importBtn.topAnchor.constraint(equalTo: createBtn.bottomAnchor, constant: 25),
            importBtn.widthAnchor.constraint(equalToConstant: 175),
            importBtn.heightAnchor.constraint(equalToConstant: 40),
            ])
    }

    @objc func createWalletAction(sender: UIButton) {
        delegate?.didPressCreateWallet(in: self)
    }
    @objc func importWalletAction(sender: UIButton) {
        delegate?.didPressImportWallet(in: self)
    }
}
