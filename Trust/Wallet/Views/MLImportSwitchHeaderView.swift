// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol MLImportSwitchHeaderViewDelegate: class {
    func didSwitchImportStyle(importSelectionType:ImportSelectionType)
}

class MLImportSwitchHeaderView: UIView {

    weak open var delegate: MLImportSwitchHeaderViewDelegate?
    lazy var importTitleLabel: UILabel = {
        var importLabel: UILabel
        importLabel = UILabel()
        importLabel.translatesAutoresizingMaskIntoConstraints = false
        importLabel.textAlignment = .left
        importLabel.textColor = AppStyle.PingFangSC24.textColor
        importLabel.font = UIFont.boldSystemFont(ofSize: 24)
//            AppStyle.PingFangSC24.font
        importLabel.text = R.string.localizable.welcomeImportWalletButtonTitle() + "!"
        return importLabel
    }()
    lazy var phraseBtn: UIButton = {
        var phraseBtn = UIButton(type: UIButtonType.custom)
        phraseBtn.translatesAutoresizingMaskIntoConstraints = false
        phraseBtn.setTitle(R.string.localizable.phrase(), for: .normal)
        phraseBtn.setTitleColor(AppStyle.PingFangSC15.textColor, for: .normal)
        phraseBtn.titleLabel?.font = AppStyle.PingFangSC15.font
        phraseBtn.isSelected = true
        phraseBtn.addTarget(self, action: #selector(switchPhraseAndPrivateAction(sender:)), for: .touchUpInside)
        return phraseBtn
    }()
    lazy var privateBtn: UIButton = {
        var privateBtn = UIButton(type: UIButtonType.custom)
        privateBtn.translatesAutoresizingMaskIntoConstraints = false
        privateBtn.setTitle(R.string.localizable.privateKey(), for: .normal)
        privateBtn.setTitleColor(AppStyle.PingFangSC15.textColor, for: .normal)
        privateBtn.titleLabel?.font = AppStyle.PingFangSC15.font
        privateBtn.addTarget(self, action: #selector(switchPhraseAndPrivateAction(sender:)), for: .touchUpInside)
        return privateBtn
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.backgroundColor = UIColor.red
        return underDynamicLine
    }()
    @objc func switchPhraseAndPrivateAction(sender: UIButton) {
        phraseBtn.isSelected = false
        privateBtn.isSelected = false
        sender.isSelected = true
        var importSelectionType : ImportSelectionType
        if phraseBtn.isSelected {
            privateBtn.isSelected = false
            importSelectionType = .mnemonic
        } else {
            phraseBtn.isSelected = false
            importSelectionType = .privateKey
        }
        delegate?.didSwitchImportStyle(importSelectionType: importSelectionType)
        updateUnderLineAnimation()
    }
    private func updateUnderLineAnimation() {

        if self.phraseBtn.isSelected {
            UIView.animate(withDuration: 0.5) {
                self.underDynamicLine.center.x = self.phraseBtn.center.x
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.underDynamicLine.center.x = self.privateBtn.center.x
            }
        }

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let phraseBtnW: CGRect = sizeWithText(text: R.string.localizable.phrase() as NSString, font: AppStyle.PingFangSC15.font, size: CGSize.init(width: 1000, height: 20))
        let privateBtnW: CGRect = sizeWithText(text: R.string.localizable.privateKey() as NSString, font: AppStyle.PingFangSC15.font, size: CGSize.init(width: 1000, height: 20))
        NSLayoutConstraint.activate([
            importTitleLabel.leftAnchor.constraint(equalTo: self.layoutGuide.leftAnchor, constant: 25),
            importTitleLabel.topAnchor.constraint(equalTo: self.layoutGuide.topAnchor, constant: 0),
            phraseBtn.leftAnchor.constraint(equalTo: self.layoutGuide.leftAnchor, constant: 25),
            phraseBtn.topAnchor.constraint(equalTo: importTitleLabel.bottomAnchor, constant: 19),
            phraseBtn.widthAnchor.constraint(equalToConstant: phraseBtnW.width + 5),
            phraseBtn.heightAnchor.constraint(equalToConstant: 20),
            privateBtn.leftAnchor.constraint(equalTo: phraseBtn.rightAnchor, constant: 30),
            privateBtn.topAnchor.constraint(equalTo: importTitleLabel.bottomAnchor, constant: 19),
            privateBtn.widthAnchor.constraint(equalToConstant: privateBtnW.width + 5),
            privateBtn.heightAnchor.constraint(equalToConstant: 20),
            underDynamicLine.topAnchor.constraint(equalTo: phraseBtn.bottomAnchor, constant: 5),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 28),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 2),
            underDynamicLine.centerXAnchor.constraint(equalTo: phraseBtn.centerXAnchor, constant: 0),
            ])
    }
    func setup() {
        self.backgroundColor = UIColor.white
        addSubview(importTitleLabel)
        addSubview(phraseBtn)
        addSubview(privateBtn)
        addSubview(underDynamicLine)
    }

    func calculationheight() -> CGFloat {
        return  34 + 19 + 33 + 5 + 2
    }
    func getTitle() -> String {
        if phraseBtn.isSelected {
            return (phraseBtn.titleLabel?.text)!
        } else {
            return (privateBtn.titleLabel?.text)!
        }
    }
}
