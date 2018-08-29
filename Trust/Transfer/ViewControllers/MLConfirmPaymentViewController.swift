// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt
import Result
import StatefulViewController

protocol MLConfirmPaymentViewControllerDelegate: class {
//    func sureAction(viewController: MLConfirmPaymentViewController)
    func dismissAction(viewController: MLConfirmPaymentViewController)
}

class MLConfirmPaymentViewController: UIViewController {

    weak var delegate: MLConfirmPaymentViewControllerDelegate?
    private let keystore: Keystore
    let session: WalletSession
    lazy var sendTransactionCoordinator = {
        return SendTransactionCoordinator(session: self.session, keystore: keystore, confirmType: confirmType, server: server)
    }()
    lazy var viewModel: ConfirmPaymentViewModel = {
        //TODO: Refactor
        return ConfirmPaymentViewModel(type: self.confirmType)
    }()
    var configurator: TransactionConfigurator
    let confirmType: ConfirmType
    let server: RPCServer
    var didCompleted: ((Result<ConfirmResult, AnyError>) -> Void)?

    private let fullFormatter = EtherNumberFormatter.full

    private var gasLimit: BigInt {
        return configurator.configuration.gasLimit
    }
    private var gasPrice: BigInt {
        return configurator.configuration.gasPrice
    }
    private var totalFee: BigInt {
        return gasPrice * gasLimit
    }
    private var gasViewModel: GasViewModel {
        return GasViewModel(fee: totalFee, server: configurator.server, store:configurator.session.tokensStorage, formatter: fullFormatter)
    }

    lazy var fullView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        var effecview = UIVisualEffectView(effect: blur)
        effecview.alpha = 0.95
        effecview.translatesAutoresizingMaskIntoConstraints = false
        effecview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return effecview
    }()
    lazy var fullView2: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effec = UIVibrancyEffect(blurEffect: blur)
        var effecview = UIVisualEffectView(effect: effec)
        effecview.alpha = 0.8
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
        titleLabel.text = NSLocalizedString("ML.Transaction.cell.Detailsofpayment", value: "支付详情", comment: "")
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
    lazy var payInfo: MLConfirmInfoLabel = {
        var payInfo: MLConfirmInfoLabel
        payInfo = MLConfirmInfoLabel(frame: .zero)
        payInfo.style = .style1
        payInfo.leftLabel.text = NSLocalizedString("ML.Transaction.cell.Detailsofpayment", value: "支付详情", comment: "")
        payInfo.rightLabel.font = UIFont.systemFont(ofSize: 13)
        payInfo.rightLabel.text = NSLocalizedString("ML.Transaction.cell.tokenTransfer.title", value: "转账", comment: "")
        return payInfo
    }()
    lazy var enterAddressInfo: MLConfirmInfoLabel = {
        var enterAddressInfo: MLConfirmInfoLabel
        enterAddressInfo = MLConfirmInfoLabel(frame: .zero)
        enterAddressInfo.style = .style1
        enterAddressInfo.leftLabel.text = NSLocalizedString("ML.Transaction.cell.Transfertotheaddress", value: "转入地址", comment: "")
        enterAddressInfo.rightLabel.font = UIFont.systemFont(ofSize: 12)
        return enterAddressInfo
    }()
    lazy var payWalletInfo: MLConfirmInfoLabel = {
        var payWalletInfo: MLConfirmInfoLabel
        payWalletInfo = MLConfirmInfoLabel(frame: .zero)
        payWalletInfo.style = .style1
        payWalletInfo.leftLabel.text = NSLocalizedString("ML.Transaction.cell.PaymentPurse", value: "付款钱包", comment: "")
        payWalletInfo.rightLabel.font = UIFont.systemFont(ofSize: 13)
        return payWalletInfo
    }()
    lazy var minerCostInfo: MLConfirmInfoLabel = {
        var minerCostInfo: MLConfirmInfoLabel
        minerCostInfo = MLConfirmInfoLabel(frame: .zero)
        minerCostInfo.style = .style2
        minerCostInfo.leftLabel.text = NSLocalizedString("ML.Transaction.cell.MinerCost", value: "矿工费用", comment: "")
        minerCostInfo.rightLabel.font = UIFont.systemFont(ofSize: 15)
        minerCostInfo.rightLabel.textAlignment = NSTextAlignment.right
        minerCostInfo.rightLabel.textColor = Colors.titleBlackcolor
        minerCostInfo.rightLabel2.textAlignment = NSTextAlignment.right
        minerCostInfo.rightLabel2.textColor = Colors.detailTextgraycolor

        return minerCostInfo
    }()

    lazy var amountLabel: MLConfirmInfoLabel = {
        var amountLabel: MLConfirmInfoLabel
        amountLabel = MLConfirmInfoLabel(frame: .zero)
        amountLabel.style = .style1
        amountLabel.leftLabel.text = NSLocalizedString("ML.Transaction.cell.Amountofmoney", value: "金额", comment: "")
        amountLabel.leftLabel.font = UIFont.systemFont(ofSize: 13)
        amountLabel.leftLabel.textColor = Colors.titleBlackcolor
        amountLabel.rightLabel.font = UIFont.systemFont(ofSize: 15)
        amountLabel.rightLabel.textColor = Colors.titleBlackcolor
        amountLabel.rightLabel.textAlignment = NSTextAlignment.right
        return amountLabel
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            payInfo,
            enterAddressInfo,
            payWalletInfo,
            minerCostInfo,
//            .spacer(height: 10),
            amountLabel,
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()

    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton.init(type: UIButtonType.custom)
        sureBtn.translatesAutoresizingMaskIntoConstraints = false
        sureBtn.backgroundColor = UIColor(hex: "F02E44")
        sureBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        sureBtn.setTitle(NSLocalizedString("transaction.confirmation.label.title", value: "确认", comment: ""), for: .normal)
        sureBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.masksToBounds = true
        sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: .touchUpInside)
        return sureBtn
    }()

    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(type: UIButtonType.custom)
        closeBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.setImage(R.image.ml_wallet_btn_error(), for: UIControlState())
        closeBtn.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)
        return closeBtn
    }()

    @objc func sureAction(sender: UIButton) {
        verifyPasswordVC()
//        delegate?.sureAction(viewController: self)
    }
    @objc func dismissVC() {
        delegate?.dismissAction(viewController: self)
    }

    lazy var walletPasswordVC: MLWalletPasswordViewController = {
        let walletPasswordVC = MLWalletPasswordViewController(session: session)
        walletPasswordVC.delegate = self
        walletPasswordVC.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH!)
        return walletPasswordVC
    }()

    private func verifyPasswordVC() {
        self.view.addSubview(walletPasswordVC.view)
        walletPasswordVC.start {
            self.send()
        }
    }
    private func dismissVerifyPassword(vc: MLWalletPasswordViewController) {
        vc.end {
            vc.view.removeFromSuperview()
        }
    }

    init(
        session: WalletSession,
        keystore: Keystore,
        configurator: TransactionConfigurator,
        confirmType: ConfirmType,
        server: RPCServer
        ) {
        self.session = session
        self.keystore = keystore
        self.configurator = configurator
        self.confirmType = confirmType
        self.server = server

        super.init(nibName: nil, bundle: nil)

//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.transactionSlider(), style: .done, target: self, action: #selector(edit))
//        view.backgroundColor = viewModel.backgroundColor
//        navigationItem.title = viewModel.title

//        errorView = ErrorView(onRetry: { [weak self] in
//            self?.fetch()
//        })
//        loadingView = LoadingView()

//        view.addSubview(stackView)
//        view.addSubview(footerStack)
        fetch()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fetch() {
//        startLoading()
        configurator.load { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.reloadView()
//                self.endLoading()
            case .failure(let error): break
//                self.endLoading(animated: true, error: error, completion: nil)
            }
        }
        configurator.configurationUpdate.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.reloadView()
        }
    }

    private func reloadView() {
        let viewModel = ConfirmPaymentDetailsViewModel(
            transaction: configurator.previewTransaction(),
            session: session,
            server: server
        )
        self.configure(for: viewModel)
    }
    private func updateSubmitButton() {
        let status = configurator.balanceValidStatus()
        let buttonTitle = viewModel.getActionButtonText(
            status, config: configurator.session.config,
            transfer: configurator.transaction.transfer
        )
        sureBtn.isEnabled = status.sufficient
        sureBtn.setTitle(buttonTitle, for: .normal)
    }

    private func updateInfo(for detailsViewModel: ConfirmPaymentDetailsViewModel) {
        self.enterAddressInfo.rightLabel.text = detailsViewModel.transaction.address?.description
        self.payWalletInfo.rightLabel.text = detailsViewModel.session.account.address.description
//        self.minerCostInfo.rightLabel.text = detailsViewModel.estimatedMinerCostFormulaWithEth
        self.minerCostInfo.rightLabel.text = detailsViewModel.estimatedMinerCostFormulaWithEth
        self.minerCostInfo.rightLabel2.text = detailsViewModel.estimatedMinerCostFormula
        self.amountLabel.rightLabel.text = detailsViewModel.absoluteAmountString
        print("gasLimit,gasPrice,",gasLimit,gasPrice)
    }
    @objc func send() {
        self.displayLoading()
        let transaction = configurator.signTransaction
        self.sendTransactionCoordinator.send(transaction: transaction) { [weak self] result in
            guard let `self` = self else { return }
            self.didCompleted?(result)
            self.hideLoading()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//                view.backgroundColor = UIColor.clear
        view.addSubview(fullView)
        fullView.contentView.addSubview(fullView2)
        view.addSubview(bottomView)
        bottomView.addSubview(closeBtn)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(underDynamicLine)

        bottomView.addSubview(payInfo)
        bottomView.addSubview(enterAddressInfo)
        bottomView.addSubview(payWalletInfo)
        bottomView.addSubview(minerCostInfo)
        bottomView.addSubview(amountLabel)
        bottomView.addSubview(stackView)

        bottomView.addSubview(sureBtn)

        bottomView.frame = CGRect(x: 0, y: kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
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
//            bottomView.topAnchor.constraint(equalTo: view.topAnchor, constant:  kScreenH!),
//
//            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
//            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
//            bottomView.heightAnchor.constraint(equalToConstant: 0.63 * kScreenH!),

            closeBtn.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 15),
            closeBtn.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 17),
            closeBtn.widthAnchor.constraint(equalToConstant: 30),
            closeBtn.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 34),
            titleLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            underDynamicLine.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 0),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 40),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 1),
            stackView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            stackView.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25),
            stackView.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: sureBtn.topAnchor, constant: -20),
            //            payInfo.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            //            payInfo.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25),
            //            payInfo.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 10),
            //            payInfo.bottomAnchor.constraint(equalTo: sureBtn.topAnchor, constant: -20),
            //amountLabel.heightAnchor.constraint(equalToConstant: 60),
            sureBtn.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25),
            sureBtn.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25),

            sureBtn.heightAnchor.constraint(equalToConstant: 40),
            sureBtn.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30-KBottomSafeHeight),
            ])
    }

    private func configure(for detailsViewModel: ConfirmPaymentDetailsViewModel) {
//        stackView.removeAllArrangedSubviews()
        updateSubmitButton()
        updateInfo(for: detailsViewModel)

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

    func start() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame = CGRect(x: 0, y: 0.37 * kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
        }) {(_ Bool) in
        }
    }
    func end(closure:@escaping ()->()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomView.frame = CGRect(x: 0, y: kScreenH!, width: kScreenW, height: 0.63 * kScreenH!)
        }) { (_ Bool) in
            closure()
        }
    }
}
extension MLConfirmPaymentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        browserDelegate?.did(action: .beginEditing)
    }
}

extension MLConfirmPaymentViewController: MLWalletPasswordViewControllerDelegate {
    func dismissAction(viewController: MLWalletPasswordViewController) {
        self.dismissVerifyPassword(vc:viewController)
    }
}
