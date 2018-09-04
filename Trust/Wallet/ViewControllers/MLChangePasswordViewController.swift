// Copyright DApps Platform Inc. All rights reserved.

import Foundation

protocol MLChangePasswordViewControllerDelegate: class {

    func didDismiss()
    func didImport()
}
class MLChangePasswordViewController: UIViewController {

    weak var delegate: MLChangePasswordViewControllerDelegate?

    var keystore: Keystore
    var wallet: WalletInfo
    lazy var cPwdField: UnderLineTextFiled = {
        var cPwdField = UnderLineTextFiled(frame: .zero)
        cPwdField.translatesAutoresizingMaskIntoConstraints = false
        cPwdField.isSecureTextEntry = true
        cPwdField.placeholder = "当前密码"
        cPwdField.underLineColor = Colors.textgraycolor
        cPwdField.font = UIFont.init(name: "PingFang SC", size: 12)
        cPwdField.delegate = self
        return cPwdField
    }()
    lazy var passwordField: UnderLineTextFiled = {
        let passwordField = UnderLineTextFiled(frame: .zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont.init(name: "PingFang SC", size: 12)
        passwordField.placeholder =  "新密码"
        passwordField.isSecureTextEntry = true
        passwordField.underLineColor = Colors.textgraycolor
        passwordField.delegate = self;
        return passwordField
    }()
    lazy var repasswordField: UnderLineTextFiled = {
        let repasswordField = UnderLineTextFiled(frame: .zero)
        repasswordField.translatesAutoresizingMaskIntoConstraints = false
        repasswordField.font = UIFont.init(name: "PingFang SC", size: 12)
        repasswordField.placeholder = "重复新密码"
        repasswordField.isSecureTextEntry = true
        repasswordField.delegate = self;
        repasswordField.underLineColor = Colors.textgraycolor
        return repasswordField
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            cPwdField,
            passwordField,
            repasswordField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        return stackView
    }()
    lazy var tipsLabel: UILabel = {
        let tipsLabel: UILabel
        tipsLabel = UILabel()
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.text = "忘记密码？导入助记词或私钥可重置密码。"
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = Colors.detailTextgraycolor
        tipsLabel.numberOfLines = 1
        tipsLabel.font = UIFont.systemFont(ofSize: 11)
        return tipsLabel
    }()
    lazy var importBtn: UIButton = {
        let importBtn = UIButton.init(type: UIButtonType.custom)
        importBtn.translatesAutoresizingMaskIntoConstraints = false
        importBtn.setTitleColor(Colors.f02e44color, for: .normal)
        importBtn.setTitle("马上导入", for: .normal)
        importBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 12)
        importBtn.addTarget(self, action: #selector(importAction), for: .touchUpInside)
        return importBtn
    }()

    func addSaveBtn() -> UIButton {
        let saveBtn = UIButton(type: UIButtonType.custom)
        saveBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveBtn.setTitle("完成", for: UIControlState.normal)
        saveBtn.setTitleColor(Colors.f02e44color, for: UIControlState.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveBtn.addTarget(self, action: #selector(finish), for: UIControlEvents.touchUpInside)
        return saveBtn
    }
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }
    init(
        keystore: Keystore,
        wallet: WalletInfo
        ) {
        self.keystore = keystore
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "更改密码"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addSaveBtn())
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        setup()
    }
    func setup() {
        view.addSubview(cPwdField)
        view.addSubview(passwordField)
        view.addSubview(repasswordField)
        view.addSubview(stackView)
        view.addSubview(tipsLabel)
        view.addSubview(importBtn)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: kNavigationBarHeight + kStatusBarHeight + 40),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 105),

            tipsLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            tipsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            importBtn.leftAnchor.constraint(equalTo: tipsLabel.rightAnchor, constant: 5),
//            importBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            importBtn.centerYAnchor.constraint(equalTo: tipsLabel.centerYAnchor, constant: 0),
            importBtn.widthAnchor.constraint(equalToConstant: 100),
            importBtn.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    @objc func finish() {
        guard !"".kStringIsEmpty(cPwdField.text) else {
            MLProgressHud.showError(error: MLErrorType.PasswordEmpty as NSError)
            return
        }
        guard "".isPassword(pasword: passwordField.text ?? "") else {
            MLProgressHud.showError(error: MLErrorType.PasswordformatError as NSError)
            return
        }
        if passwordField.text ?? "" != repasswordField.text ?? "" {
            MLProgressHud.showError(error: MLErrorType.PasswordNotEqual as NSError)
            return
        }
//        keystore.getPassword(for: wallet.currentAccount.wallet!)

        guard MLKeychain().verify(passworld: cPwdField.text!, service: wallet.currentAccount.address.description) else {
            MLProgressHud.showError(error: MLErrorType.PasswordError as NSError)
            return
        }
        MLKeychain().saveKeychain(service: wallet.currentAccount.address.description, data: passwordField.text! as AnyObject)
//        if self.keystore.setPassword(passwordField.text!, for: wallet.currentAccount.wallet!) {
            MLProgressHud.show(message: "修改密码成功！")
            delegate?.didDismiss()
//        }
    }
    @objc func dismissViewController() {
        delegate?.didDismiss()
    }
    @objc func importAction() {
        delegate?.didImport()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        browserDelegate?.did(action: .beginEditing)
    }
}