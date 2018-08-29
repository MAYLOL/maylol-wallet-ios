// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import IBAnimatable

protocol MLImportPrivateViewDelegate: class {
    func didPressServise()
}
class MLImportPrivateView: UIView {


    weak var delegate: MLImportPrivateViewDelegate?

    lazy var placeholderLabel : UILabel = {
        var placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()

    lazy var privateTextView: AnimatableTextView = {
        var privateTextView = AnimatableTextView(frame: .zero)
        privateTextView.translatesAutoresizingMaskIntoConstraints = false
        privateTextView.placeholderText = "明文私钥"
        privateTextView.placeholderColor = AppStyle.PingFangSC10.textColor
        privateTextView.font = AppStyle.PingFangSC12.font
        var placeholderLabelConstraints = [NSLayoutConstraint]()
        privateTextView.configure(placeholderLabel: placeholderLabel, placeholderLabelConstraints: &placeholderLabelConstraints)
        privateTextView.delegate = self
        privateTextView.textColor = AppStyle.PingFangSC12.textColor
        privateTextView.textAlignment = .left
        //        privateTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        privateTextView.borderWidth = 1
        privateTextView.borderColor = AppStyle.PingFangSC10.textColor
        return privateTextView
    }()
    lazy var passwordField: UnderLineTextFiled = {
        let passwordField = UnderLineTextFiled(frame: .zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont.init(name: "PingFang SC", size: 12)
        passwordField.placeholder =  R.string.localizable.password()
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.underLineColor = Colors.textgraycolor
        return passwordField
    }()
    lazy var repasswordField: UnderLineTextFiled = {
        let repasswordField = UnderLineTextFiled(frame: .zero)
        //        repasswordField.frame.size.width = 30
        repasswordField.translatesAutoresizingMaskIntoConstraints = false
        repasswordField.font = UIFont.init(name: "PingFang SC", size: 12)
        repasswordField.placeholder = NSLocalizedString("CreateWalletRePassWord", value: "重复密码", comment: "")
        repasswordField.delegate = self
        repasswordField.isSecureTextEntry = true
        repasswordField.underLineColor = Colors.textgraycolor
        return repasswordField
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwordField,
            repasswordField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 32
        return stackView
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
    @objc func serviceAction(sender: UIButton) {
        delegate?.didPressServise()
    }
    @objc func detailAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
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
            privateTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            privateTextView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            privateTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            privateTextView.heightAnchor.constraint(equalToConstant: 70),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.topAnchor.constraint(equalTo: privateTextView.bottomAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 92),

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

            ])
    }
    private func setup() {
        addSubview(privateTextView)
        addSubview(passwordField)
        addSubview(repasswordField)
        addSubview(detailBtn)
        addSubview(readProtocolLabel)
        addSubview(serviceBtn)
        addSubview(stackView)
    }
    func observeStatus() -> Bool {
        if !privateTextView.text.isPrivateValid(value: privateTextView.text) {
//            MLErrorType.Private64CharactersError.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.Private64CharactersError as NSError)
//            print(MLErrorType.Private64CharactersError.title)
            return false
        }
        let isPassword = "".isPassword(pasword: passwordField.text ?? "")

        if !isPassword {
//            self.superview
//            MLErrorType.PasswordformatError.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.PasswordformatError as NSError)
//            print(MLErrorType.PasswordformatError.title)
            return false
        }
        if passwordField.text ?? "" != repasswordField.text ?? "" {
//            MLErrorType.PasswordNotEqual.tips(view: self.superview!)
//            print("密码前后不相等")
            MLProgressHud.showError(error: MLErrorType.PasswordNotEqual as NSError)
//            print(MLErrorType.PasswordNotEqual.title)
            return false
        }
        if !detailBtn.isSelected {
//            MLErrorType.ReadProtocolNotRead.tips(view: self.superview!)
            MLProgressHud.showError(error: MLErrorType.ReadProtocolNotRead as NSError)
//            print(MLErrorType.ReadProtocolNotRead.title)
            return false
        }
        return true
    }
    func resignResponder(){
        privateTextView.resignFirstResponder()
        passwordField.resignFirstResponder()
        repasswordField.resignFirstResponder()
    }
    func calculationheight() -> CGFloat {
        return  70 + 32 + 92 + 45 + 20
    }
    func getPrivateWord() -> String{
        return privateTextView.text
    }
    func getPassWord() -> String{
        return passwordField.text!
    }
}

extension MLImportPrivateView : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        placeholderLabel.isHidden = !textView.text.kStringIsEmpty(textView.text)

    }

    func textViewDidEndEditing(_ textView: UITextView) {

    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
}

extension MLImportPrivateView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
