// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

typealias StaduesHandle = (() -> ())

protocol MLWalletPasswordViewControllerDelegate: class {

    func dismissAction(viewController: MLWalletPasswordViewController)
//    optional func sureAction(viewController: MLWalletPasswordViewController)
}

class MLWalletPasswordViewController: UIViewController {

    weak var delegate: MLWalletPasswordViewControllerDelegate?

    var succesHandle: StaduesHandle?
//    var faildHandle: StaduesHandle
    var session: WalletSession

    lazy var fullView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        var effecview = UIVisualEffectView(effect: blur)
//        effecview.alpha = 0.95
        effecview.alpha = 0
        effecview.translatesAutoresizingMaskIntoConstraints = false
        effecview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return effecview
    }()

    lazy var fullView2: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effec = UIVibrancyEffect(blurEffect: blur)
        var effecview = UIVisualEffectView(effect: effec)
//        effecview.alpha = 0.8
        effecview.alpha = 0
        effecview.translatesAutoresizingMaskIntoConstraints = false
        effecview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissVC))
        effecview.contentView.addGestureRecognizer(tap)
        return effecview
    }()

    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = NSLocalizedString("ML.Transaction.cell.Pursecipher", value: "钱包密码", comment: "")
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
    lazy var enterPasswordLabel: UILabel = {
        let enterPasswordLabel: UILabel
        enterPasswordLabel = UILabel()
        enterPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        enterPasswordLabel.text = NSLocalizedString("ML.lock.enter.passcode.view.model.initial", value: "请输入密码", comment: "")
        enterPasswordLabel.textAlignment = .left
        enterPasswordLabel.textColor = Colors.titleBlackcolor
        enterPasswordLabel.font = UIFont.systemFont(ofSize: 12)
        return enterPasswordLabel
    }()
    lazy var passwordField: UnderLineTextFiled = {
        let passwordField = UnderLineTextFiled(frame: .zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont.init(name: "PingFang SC", size: 12)
        passwordField.placeholder = NSLocalizedString("ML.lock.enter.passcode.view.model.initial", value: "请输入密码", comment: "")
        passwordField.isSecureTextEntry = true
        passwordField.underLineColor = Colors.textgraycolor
        passwordField.delegate = self
        return passwordField
    }()
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton.init(type: UIButtonType.custom)
        sureBtn.translatesAutoresizingMaskIntoConstraints = false
        sureBtn.backgroundColor = UIColor(hex: "F02E44")
        sureBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        sureBtn.setTitle(NSLocalizedString("ML.Transaction.cell.Sure", value: "确定", comment: ""), for: .normal)
        sureBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.masksToBounds = true
        sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: .touchUpInside)
        return sureBtn
    }()

    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)
        return leftBtn
    }()

    @objc func sureAction(sender: UIButton) {
        let passWord = passwordField.text
        guard !"".kStringIsEmpty(passWord) else {
            MLProgressHud.showError(error: MLErrorType.PasswordEmpty as NSError)
            return
        }
        guard MLKeychain().verify(passworld: passWord!, service: session.account.address.description) else {
            MLProgressHud.showError(error: MLErrorType.PasswordError as NSError)
            return
        }
//        succesHandle()
//        delegate?.sureAction(viewController: self)
        self.succesHandle!()
    }

    init(
        session: WalletSession
//        successHandle:@escaping ()->(),
//        faildHandle:@escaping ()->()
        ) {
//        self.succesHandle = successHandle
//        self.faildHandle = faildHandle
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismissVC() {
//        faildHandle()
        delegate?.dismissAction(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.clear
        setup()
    }

    func setup() {
        view.addSubview(fullView)
        fullView.contentView.addSubview(fullView2)
        view.addSubview(bottomView)
        bottomView.addSubview(leftBtn)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(underDynamicLine)
        bottomView.addSubview(enterPasswordLabel)
        bottomView.addSubview(passwordField)
        bottomView.addSubview(sureBtn)
//        bottomView.frame = CGRect(x: 0, y: kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            fullView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            fullView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            fullView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            fullView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            fullView2.topAnchor.constraint(equalTo: fullView.topAnchor, constant: 0),
            fullView2.bottomAnchor.constraint(equalTo: fullView.bottomAnchor, constant: 0),
            fullView2.leftAnchor.constraint(equalTo: fullView.leftAnchor, constant: 0),
            fullView2.rightAnchor.constraint(equalTo: fullView.rightAnchor, constant: 0),

            bottomView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.37 * kScreenH!),

            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: 0.63 * kScreenH!),

            leftBtn.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 15),
            leftBtn.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 17),
            leftBtn.widthAnchor.constraint(equalToConstant: 30),
            leftBtn.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 34),
            titleLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            underDynamicLine.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 0),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 40),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            enterPasswordLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            enterPasswordLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 84),
            passwordField.topAnchor.constraint(equalTo: enterPasswordLabel.bottomAnchor, constant: 20),
            passwordField.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            passwordField.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25),
            passwordField.heightAnchor.constraint(equalToConstant: 32),
            sureBtn.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            sureBtn.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25),

            sureBtn.heightAnchor.constraint(equalToConstant: 40),
            sureBtn.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30-KBottomSafeHeight),
            ])
    }

    func start(successHandle:@escaping ()->()) {
        self.succesHandle = successHandle
//        UIView.animate(withDuration: 0.5, animations: {
//            self.bottomView.frame = CGRect(x: 0, y: 0.37 * kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
//        }) {(_ Bool) in
//        }
    }
    func end(closure:@escaping ()->()) {
//        func end() {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.bottomView.frame = CGRect(x: 0, y: kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
//        }) { (_ Bool) in
            closure()
//            self.faildHandle()
//        }
    }
}
extension MLWalletPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        browserDelegate?.did(action: .beginEditing)
    }
}
