// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import Eureka
import JSONRPCKit
import APIKit
import BigInt
import QRCodeReaderViewController
import TrustCore
import TrustKeystore

protocol MLSendViewControllerDelegate: class {
    func didPressConfirm(
        transaction: UnconfirmedTransaction,
        transfer: Transfer,
        in viewController: MLSendViewController
    )
    func didPressScan()
}

class MLSendViewController: UIViewController {
    private lazy var viewModel: SendViewModel = {
        let balance = Balance(value: transfer.type.token.valueBigInt)
        return .init(transfer: transfer, config: session.config, chainState: chainState, storage: storage, balance: balance)
    }()

    var scanString: String?{
        didSet {
           sendView.payAddressField.text = scanString
        }
    }
    var initConfigurator: TransactionConfigurator?

//    let configurator = TransactionConfigurator(
//        session: session,
//        account: account,
//        transaction: transaction,
//        server: transfer.server,
//        chainState: ChainState(server: transfer.server)
//    )
    
    weak var delegate: MLSendViewControllerDelegate?
    struct Values {
        static let address = "address"
        static let amount = "amount"
    }
    lazy var sendView: MLSendView = {
        var sendView = MLSendView(frame: .zero)
        sendView.viewModel = viewModel
        sendView.scanBtn.addTarget(self, action: #selector(scanAction(sender:)), for: UIControlEvents.touchUpInside)
        sendView.translatesAutoresizingMaskIntoConstraints = false
        return sendView
    }()

    let session: WalletSession
    let account: Account
    let transfer: Transfer
    let storage: TokensDataStore
    let chainState: ChainState
    private var allowedCharacters: String = {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        return "0123456789" + decimalSeparator
    }()
    private var data = Data()
    init(
        session: WalletSession,
        storage: TokensDataStore,
        account: Account,
        transfer: Transfer,
        chainState: ChainState
        ) {
        self.session = session
        self.account = account
        self.transfer = transfer
        self.storage = storage
        self.chainState = chainState
        super.init(nibName: nil, bundle: nil)
        //        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        sendView.nextBtn.addTarget(self, action: #selector(nextAction(sender:)), for: UIControlEvents.touchUpInside)
        refreshCoordinator()
        setup()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    func setup() {
        self.view.addSubview(sendView)
        NSLayoutConstraint.activate([
            self.sendView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            self.sendView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            self.sendView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            self.sendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ])
    }

//    func update(configuration: TransactionConfiguration) {
//        self.configuration = configuration
//    }
//
//    @objc func save() {
//        guard gasLimit <= ConfigureTransaction.gasLimitMax else {
//            return displayError(error: ConfigureTransactionError.gasLimitTooHigh)
//        }
//
//        guard totalFee <= ConfigureTransaction.gasFeeMax else {
//            return displayError(error: ConfigureTransactionError.gasFeeTooHigh(transfer.server))
//        }
//
//        let data: Data = {
//            if dataString.isEmpty {
//                return Data()
//            }
//            return Data(hex: dataString.drop0x)
//        }()
//
//        let configuration = TransactionConfiguration(
//            gasPrice: gasPrice,
//            gasLimit: gasLimit,
//            data: data,
//            nonce: nonce
//        )
////        delegate?.didEdit(configuration: configuration, in: self)
//    }
    @objc func nextAction(sender: UIButton) {
        send()
    }
    func send() {
        let errors = sendView.validate()
        guard errors == nil else { return }
        let addressString = sendView.payAddressField.text ?? ""
        guard let address = EthereumAddress(string: addressString) else {
            return displayError(error: Errors.invalidAddress)
        }
        viewModel.amount = sendView.transferAmountField.text ?? ""
        
        let amountString = viewModel.amount
        let parsedValue: BigInt? = {
            switch transfer.type {
            case .ether, .dapp:
                return EtherNumberFormatter.full.number(from: amountString, units: .ether)
            case .token(let token):
                return EtherNumberFormatter.full.number(from: amountString, decimals: token.decimals)
            }
        }()
        guard let value = parsedValue else {
            return displayError(error: SendInputErrors.wrongInput)
        }


        if (gasLimit > GasLimitConfiguration.max) {
            return displayError(error: MLErrorType.gasTooHeightError)
        }
        if (gasLimit < GasLimitConfiguration.min){
            return displayError(error: MLErrorType.gasTooHeightError)
        }

        if gasPrice < GasPriceConfiguration.min {
            return displayError(error: MLErrorType.gasPriseTooLowError)
        }
        if gasPrice > GasPriceConfiguration.max {
            return displayError(error: MLErrorType.gasPriseTooHeightError)
        }

        let transaction = UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: address,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: .none
        )
        self.delegate?.didPressConfirm(transaction: transaction, transfer: transfer, in: self)
    }

    private let fullFormatter = EtherNumberFormatter.full

    private var defaultGasLimit: BigInt{
        return TransactionConfigurator.gasLimitPu(type: transfer.type)
    }

    private var defaultGasPriceBigInt:BigInt {
        return GasPriceConfiguration.max
    }
    private var gasLimit: BigInt {
        if sendView.superSelect {
            let gasBigInt: BigInt =  BigInt(sendView.customGasField.text ?? "0")!
            return gasBigInt
        }
        return defaultGasLimit
    }
    private var gasPrice: BigInt {
//        return min(max(BigInt(self.sendView.minerCostSlider.value * 10000), GasPriceConfiguration.min), GasPriceConfiguration.max)
        if sendView.superSelect {
            let gasPriceBigInt: BigInt = EtherNumberFormatter.full.number(from: sendView.customGasPriceField.text ?? "0", units: UnitConfiguration.gasPriceUnit)!
            return gasPriceBigInt
        }
        let gasPriceBigInt: BigInt = EtherNumberFormatter.full.number(from: String(self.sendView.minerCostSlider.value), units: UnitConfiguration.gasPriceUnit)!
        return gasPriceBigInt
//        return min(max(gasPriceBigInt, GasPriceConfiguration.min), GasPriceConfiguration.max)
    }
    private var totalFee: BigInt {
        return gasPrice * gasLimit
    }
    private var gasViewModel: GasViewModel {
        return GasViewModel(fee: totalFee, server: chainState.server, store:storage, formatter: fullFormatter)
    }
    func refreshCoordinator() {
        refreshSendView()
        sendView.minerCostSlider.addTarget(self, action: #selector(costSlider(sender:)), for: UIControlEvents.valueChanged)

//        print("gasLimit:",gasLimit)
//        print("gasPrice:",gasPrice)
//
//        print("gasViewModel:",gasViewModel)
//        gasViewModel.etherFee

//        转字符串
//        fullFormatter.string(from: transaction.gasPrice, units: UnitConfiguration.gasPriceUnit)


//        let addressString = ""
//        let address = EthereumAddress(string: addressString)
//        let amountString = "0"
//        let parsedValue: BigInt? = {
//            switch transfer.type {
//            case .ether, .dapp:
//                return EtherNumberFormatter.full.number(from: amountString, units: .ether)
//            case .token(let token):
//                return EtherNumberFormatter.full.number(from: amountString, decimals: token.decimals)
//            }
//        }()
//        let transaction = UnconfirmedTransaction(
//            transfer: transfer,
//            value: parsedValue!,
//            to: address,
//            data: data,
//            gasLimit: .none,
//            gasPrice: viewModel.gasPrice,
//            nonce: .none
//        )
//        let configurator = TransactionConfigurator(
//            session: session,
//            account: account,
//            transaction: transaction,
//            server: transfer.server,
//            chainState: ChainState(server: transfer.server)
//        )
//        initConfigurator = configurator
////        configurator.transaction.gasLimit
////        configurator.transaction.gasPrice
//        sendView.minerCostSlider.minimumValue = 1
//        sendView.minerCostSlider.minimumValue = 60
//
////        sendView.updateSliderCostStr(gasLimit:Double(sendView.minerCostSlider.minimumValue))
////        minerCostSlider.minimumValue = 1
////        minerCostSlider.maximumValue = 60
    }
    @objc func costSlider(sender: UISlider) {
        refreshSendView()
    }

    func refreshSendView() {
        var model:GasViewModel =  GasViewModel(fee: totalFee, server: chainState.server, store:storage, formatter: fullFormatter)
        sendView.costAmound.text = model.etherFee
    }

    @objc func scanAction(sender:UIButton) {
        delegate?.didPressScan()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.applyTintAdjustment()
    }
}
