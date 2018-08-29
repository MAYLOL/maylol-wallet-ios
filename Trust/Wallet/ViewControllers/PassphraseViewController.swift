// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import TrustKeystore

protocol PassphraseViewControllerDelegate: class {
    func didPressVerify(in controller: PassphraseViewController, with account: Wallet, words: [String])
    func pushDone(in controller: PassphraseViewController, with account: Wallet)
}

enum PassphraseMode {
    case showOnly
    case showAndVerify
}

final class DarkPassphraseViewController: PassphraseViewController {

}

class PassphraseViewController: UIViewController {

    let viewModel = PassphraseViewModel()
    let account: Wallet
    let words: [String]
    lazy var actionButton: UIButton = {
        let button = Button(size: .large, style: .solid)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(R.string.localizable.next(), for: .normal)
        return button
    }()
    let copyButton = Button(size: .extraLarge, style: .clear)
    weak var delegate: PassphraseViewControllerDelegate?
    init(
        account: Wallet,
        words: [String],
        mode: PassphraseMode = .showOnly
    ) {
        self.account = account
        self.words = words
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = viewModel.backgroundColor

        setupViews(for: mode)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setupViews(for mode: PassphraseMode) {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = viewModel.title
        titleLabel.font = AppStyle.PingFangSC24.font
        titleLabel.textColor = AppStyle.PingFangSC24.textColor
        titleLabel.textAlignment = .left
        let subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = viewModel.subTitle
        subTitleLabel.font = AppStyle.PingFangSC24.font
        subTitleLabel.textColor = AppStyle.PingFangSC24.textColor
        subTitleLabel.textAlignment = .left
        let subTitleTipsLabel = UILabel()
        subTitleTipsLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleTipsLabel.text = viewModel.subTitleTips
        subTitleTipsLabel.numberOfLines = 0
        subTitleTipsLabel.font = AppStyle.PingFangSC14.font
        subTitleTipsLabel.textColor = AppStyle.PingFangSC14.textColor
        subTitleTipsLabel.textAlignment = .left
        let wordsLabel = UILabel()
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsLabel.numberOfLines = 0
        wordsLabel.text = words.joined(separator: "  ")
        wordsLabel.backgroundColor = .clear
        wordsLabel.font = AppStyle.PingFangSC15.font
        wordsLabel.textColor = Colors.titleBlackcolor
        wordsLabel.textAlignment = .center
        wordsLabel.numberOfLines = 3
        wordsLabel.isUserInteractionEnabled = true
        wordsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyGesture)))
        let wordBackgroundView = PassphraseBackgroundShadow()
        wordBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        wordBackgroundView.isUserInteractionEnabled = true
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(subTitleTipsLabel)
        view.addSubview(wordsLabel)
        view.addSubview(wordBackgroundView)
        wordBackgroundView.addSubview(wordsLabel)
        view.addSubview(actionButton)
        let wordsRect = sizeWithText(text: wordsLabel.text! as NSString, font: AppStyle.PingFangSC15.font, size: CGSize(width: kScreenW - 82, height: 120))
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130 - kStatusBarHeight),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            subTitleTipsLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 25),
            subTitleTipsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            subTitleTipsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            wordsLabel.widthAnchor.constraint(equalToConstant: wordsRect.width),
            wordsLabel.heightAnchor.constraint(equalToConstant: wordsRect.height),
            wordsLabel.topAnchor.constraint(equalTo: subTitleTipsLabel.bottomAnchor, constant: 39),
            wordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            wordBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            wordBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            wordBackgroundView.topAnchor.constraint(equalTo: wordsLabel.topAnchor, constant: -StyleLayout.sideMargin),
            wordBackgroundView.bottomAnchor.constraint(equalTo: wordsLabel.bottomAnchor, constant: StyleLayout.sideMargin),
            actionButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor, constant: -StyleLayout.sideMargin),
        ])

        copyButton.addTarget(self, action: #selector(copyAction(_:)), for: .touchUpInside)

        switch mode {
        case .showOnly:
            actionButton.isHidden = true
        case .showAndVerify:
            actionButton.isHidden = false
        }
        actionButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
    }

    func presentShare(in sender: UIView) {
        let copyValue = words.joined(separator: " ")
        showShareActivity(from: sender, with: [copyValue])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: R.image.ml_wallet_btn_return(), style: .plain, target: self, action: #selector(pushDone(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
    }
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController(sender: UIButton) {
        delegate?.pushDone(in: self, with: account)
    }
    
    @objc private func copyAction(_ sender: UIButton) {
        presentShare(in: sender)
    }

    @objc private func copyGesture(_ sender: UIGestureRecognizer) {
        presentShare(in: sender.view!)
    }

    @objc private func nextAction(_ sender: UIButton) {
        delegate?.didPressVerify(in: self, with: account, words: words)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
