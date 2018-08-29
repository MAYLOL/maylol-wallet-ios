// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol WelcomeViewDelegate: class {
    func didPressCreateWallet(createWalletViewModel: CreateWalletViewModel)
    func didPressImportWallet()
    func didPressServise()
}

class WelcomeView: UIView {

    weak var delegate: WelcomeViewDelegate?

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.text = R.string.localizable.welcomeCreateWalletButtonTitle() + "!"
        return titleLabel
    }()

    lazy var subtitleLabel: UILabel = {
        var subtitleLabel: UILabel
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let str = NSLocalizedString("CreateWalletSettinglabelsubtitle", value: "·密码用于保护私钥交易合交易授权，强度非常重要\n·我们不存储密码，也无法帮您找回，请务必牢记", comment: "")
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = Colors.detailTextgraycolor
        subtitleLabel.numberOfLines = 4
        subtitleLabel.font = UIFont.systemFont(ofSize: 9)
        subtitleLabel.attributedText = appendColorStrWithString(str: str, font: 9, color: Colors.detailTextgraycolor, lineSpaceing: 4, alignment: .left)
        return subtitleLabel
    }()
    lazy var createWalletField: UnderLineTextFiled = {
        var createWalletField = UnderLineTextFiled(frame: .zero)
        createWalletField.isSecureTextEntry = false
        createWalletField.underLineColor = Colors.textgraycolor
        createWalletField.font = UIFont.init(name: "PingFang SC", size: 12)
        createWalletField.placeholder = NSLocalizedString("CreateWalletSettingWalletName", value: "钱包名称", comment: "")
        createWalletField.delegate = self
        return createWalletField
    }()
    lazy var passwordField: UnderLineTextFiled = {
        let passwordField = UnderLineTextFiled(frame: .zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont.init(name: "PingFang SC", size: 12)
        passwordField.placeholder =  R.string.localizable.password()
        passwordField.isSecureTextEntry = true
        passwordField.underLineColor = Colors.textgraycolor
        passwordField.delegate = self
        //
        return passwordField
    }()
    lazy var repasswordField: UnderLineTextFiled = {
        let repasswordField = UnderLineTextFiled(frame: .zero)
        //        repasswordField.frame.size.width = 30
        repasswordField.translatesAutoresizingMaskIntoConstraints = false
        repasswordField.font = UIFont.init(name: "PingFang SC", size: 12)
        repasswordField.placeholder = NSLocalizedString("CreateWalletRePassWord", value: "重复密码", comment: "")
        repasswordField.isSecureTextEntry = true
        repasswordField.delegate = self
        repasswordField.underLineColor = Colors.textgraycolor
        return repasswordField
    }()
    lazy var readProtocolLabel: UILabel = {
        let readProtocolLabel: UILabel
        readProtocolLabel = UILabel()
        readProtocolLabel.translatesAutoresizingMaskIntoConstraints = false
        readProtocolLabel.text = NSLocalizedString("CreateWalletSettingServicePrivacyClause1", value: "我已经仔细阅读并同意", comment: "")
        readProtocolLabel.textAlignment = .center
        readProtocolLabel.textColor = UIColor.black
        readProtocolLabel.numberOfLines = 0
        readProtocolLabel.font = UIFont.systemFont(ofSize: 11)
        return readProtocolLabel
    }()
    lazy var serviceBtn: UIButton = {
        //        let serviceBtn = Button(size: .normal, style: .border)
        let serviceBtn = UIButton.init(type: UIButtonType.custom)
        serviceBtn.translatesAutoresizingMaskIntoConstraints = false
        serviceBtn.setTitle(NSLocalizedString("CreateWalletSettingServicePrivacyClause", value: "服务隐私条款", comment: ""), for: .normal)
        serviceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        serviceBtn.setTitleColor(UIColor.red, for: .normal)
        serviceBtn.addTarget(self, action: #selector(serviceAction(sender:)), for: .touchUpInside)
        return serviceBtn
    }()
    lazy var detailBtn: UIButton = {
        //        let detailBtn = Button(size: .normal, style: .border)
        let detailBtn = UIButton.init(type: UIButtonType.custom)
        detailBtn.translatesAutoresizingMaskIntoConstraints = false
        detailBtn.setImage(R.image.ml_servisebtn_normal(), for: .normal)
        detailBtn.setImage(R.image.ml_servisebtn_select(), for: .selected)
        detailBtn.addTarget(self, action: #selector(detailAction(sender:)), for: .touchUpInside)
        return detailBtn
    }()

    lazy var createBtn: UIButton = {
        let createBtn = UIButton.init(type: UIButtonType.custom)
        createBtn.translatesAutoresizingMaskIntoConstraints = false
        createBtn.backgroundColor = UIColor(hex: "F02E44")
        createBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        createBtn.setTitle(R.string.localizable.creatingWallet(), for: .normal)
        createBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        createBtn.layer.cornerRadius = 5
        createBtn.layer.masksToBounds = true

        createBtn.addTarget(self, action: #selector(createWalletAction(sender:)), for: .touchUpInside)
        return createBtn
    }()

    lazy var importBtn: UIButton = {
        let importBtn = UIButton.init(type: UIButtonType.custom)
        importBtn.translatesAutoresizingMaskIntoConstraints = false
        importBtn.backgroundColor = UIColor.white
        importBtn.setTitleColor(UIColor(hex: "F02E44"), for: .normal)
        importBtn.setTitle(R.string.localizable.welcomeImportWalletButtonTitle(), for: .normal)
        importBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        importBtn.layer.cornerRadius = 5
        importBtn.layer.masksToBounds = true

        importBtn.addTarget(self, action: #selector(importWalletAction(sender:)), for: .touchUpInside)
        return importBtn
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createWalletField,
            passwordField,repasswordField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 32
        return stackView
    }()

    @objc func serviceAction(sender: UIButton) {
        delegate?.didPressServise()
    }
    @objc func detailAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc func createWalletAction(sender: UIButton) {
        let isEmpty = "".kStringIsEmpty(createWalletField.text ?? "")
        if isEmpty {
//            MLErrorType.WalletNameEmptyError.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.WalletNameEmptyError as NSError)
//            print(MLErrorType.WalletNameEmptyError.title)
            return
        }
        let isPassword = "".isPassword(pasword: passwordField.text ?? "")
        if !isPassword {
//            MLErrorType.PasswordformatError.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.PasswordformatError as NSError)
//            print(MLErrorType.PasswordformatError.title)
            return
        }
        if passwordField.text ?? "" != repasswordField.text ?? "" {
//            MLErrorType.PasswordNotEqual.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.PasswordNotEqual as NSError)
//            print(MLErrorType.PasswordNotEqual.title)
            return
        }
        if !detailBtn.isSelected {
//            MLErrorType.ReadProtocolNotRead.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.ReadProtocolNotRead as NSError)
//            print(MLErrorType.ReadProtocolNotRead.title)
            return
        }
        let createWalletVM = CreateWalletViewModel(title: createWalletField.text!, password: passwordField.text!)
        delegate?.didPressCreateWallet(createWalletViewModel: createWalletVM)
    }

    @objc func importWalletAction(sender: UIButton) {
        delegate?.didPressImportWallet()
    }
    //    lazy var readProtocolView: ReadProtocolView = {
    //        let readProtocolView = ReadProtocolView(frame: .zero)
    //        return readProtocolView
    //    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let rectServce: CGRect = sizeWithText(text: NSLocalizedString("CreateWalletSettingServicePrivacyClause", value: "服务隐私条款", comment: "") as NSString, font: UIFont.systemFont(ofSize: 11), size: CGSize.init(width: 100, height: 20))

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100 - kStatusBarHeight),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
            subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 160),

            detailBtn.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 25),
            detailBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            detailBtn.heightAnchor.constraint(equalToConstant: 20),
            detailBtn.widthAnchor.constraint(equalToConstant: 20),

            readProtocolLabel.leadingAnchor.constraint(equalTo: detailBtn.trailingAnchor, constant: 4),
            readProtocolLabel.centerYAnchor.constraint(equalTo: detailBtn.centerYAnchor, constant: 0),

            serviceBtn.leadingAnchor.constraint(equalTo: readProtocolLabel.trailingAnchor, constant: 4),
            serviceBtn.centerYAnchor.constraint(equalTo: detailBtn.centerYAnchor, constant: 0),
            serviceBtn.heightAnchor.constraint(equalToConstant: 20),
            serviceBtn.widthAnchor.constraint(equalToConstant: rectServce.size.width + 5),

            createBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            createBtn.topAnchor.constraint(equalTo: serviceBtn.bottomAnchor, constant: 85),
            createBtn.heightAnchor.constraint(equalToConstant: 40),
            createBtn.widthAnchor.constraint(equalToConstant: 135),

            importBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 162),
            importBtn.topAnchor.constraint(equalTo: createBtn.bottomAnchor, constant: 100),
            importBtn.heightAnchor.constraint(equalToConstant: 40),
            importBtn.widthAnchor.constraint(equalToConstant: 135),

            ])
    }
    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(createWalletField)
        addSubview(passwordField)
        addSubview(repasswordField)
        //        addSubview(readProtocolView)
        addSubview(detailBtn)
        addSubview(readProtocolLabel)
        addSubview(serviceBtn)
        addSubview(createBtn)
        addSubview(importBtn)
        addSubview(stackView)
    }

    private func appendColorStrWithString(str: String, font: CGFloat, color: UIColor, lineSpaceing: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpaceing
        let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font), NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString.init(string: str, attributes: attrs)
        return attributedString
    }
    func calculationheight() -> CGFloat {
        return  586 + 100
    }
    func reset() {
        createWalletField.resignFirstResponder()
        passwordField.resignFirstResponder()
        repasswordField.resignFirstResponder()
    }
}

extension WelcomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        browserDelegate?.did(action: .beginEditing)
    }
}
