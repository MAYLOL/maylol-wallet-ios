// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import IBAnimatable
import TrustCore

protocol MLSendViewDelegate: class {
    func didHowToSetAction()
    func invideData()
}
class MLSendView: UIView {

    weak var delegate: MLSendViewDelegate?
    var superSelect: Bool = false
    var viewModel: SendViewModel? {
        didSet {
            titleLabel.text = (viewModel?.symbol)! + " " + "ML.Transaction.cell.tokenTransfer.title".localized()
            switch viewModel?.transfer.type {
            case .ether?, .dapp?:
                sixdataTV.isEditable = true
            case .token?:
                sixdataTV.isEditable = false
            case .none:
                sixdataTV.isEditable = false
            }
            minerCostSlider.minimumValue = 1
            minerCostSlider.maximumValue = 60
        }
    }
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.text = "ML.Transaction.cell.tokenTransfer.title".localized()

        return titleLabel
    }()

    lazy var scanBtn: UIButton = {
        let scanBtn = UIButton(type: UIButtonType.custom)
        scanBtn.translatesAutoresizingMaskIntoConstraints = false
        scanBtn.setImage(R.image.ml_wallet_eth_btn_scan(), for: UIControlState.normal)
        return scanBtn
    }()

    lazy var payAddressField: UnderLineTextFiled = {
        var payAddressField = UnderLineTextFiled(frame: .zero)
        payAddressField.translatesAutoresizingMaskIntoConstraints = false
        payAddressField.underLineColor = Colors.textgraycolor
        payAddressField.font = UIFont.init(name: "PingFang SC", size: 12)
//        payAddressField.placeholder = NSLocalizedString("ML.Transaction.cell.PayeeWalletAddress", value: "收款人钱包地址", comment: "")
        payAddressField.placeholder = "ML.Transaction.cell.PayeeWalletAddress".localized()
        payAddressField.textColor = Colors.detailTextgraycolor
        payAddressField.delegate = self

        return payAddressField
    }()

    lazy var transferAmountField: UnderLineTextFiled = {
        var transferAmountField = UnderLineTextFiled(frame: .zero)
        transferAmountField.translatesAutoresizingMaskIntoConstraints = false
        transferAmountField.underLineColor = Colors.textgraycolor
        transferAmountField.font = UIFont.init(name: "PingFang SC", size: 12)
//        transferAmountField.placeholder = NSLocalizedString("ML.Transaction.cell.TransferAmount", value: "转账金额", comment: "")
        transferAmountField.placeholder = "ML.Transaction.cell.TransferAmount".localized()
        transferAmountField.keyboardType = .decimalPad
        transferAmountField.textColor = Colors.detailTextgraycolor
        transferAmountField.delegate = self
        return transferAmountField
    }()
    lazy var remarksField: UnderLineTextFiled = {
        var remarksField = UnderLineTextFiled(frame: .zero)
        remarksField.translatesAutoresizingMaskIntoConstraints = false
        remarksField.underLineColor = Colors.textgraycolor
        remarksField.font = UIFont.init(name: "PingFang SC", size: 12)
//        remarksField.placeholder = NSLocalizedString("ML.Transaction.cell.Remarks", value: "备注", comment: "")
        remarksField.placeholder = "ML.Transaction.cell.Remarks".localized()
        remarksField.textColor = Colors.detailTextgraycolor
        remarksField.delegate = self
        return remarksField
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            payAddressField,
            transferAmountField,
            remarksField]
            )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    lazy var customGasStackView: UIStackView = {
        let customGasStackView = UIStackView(arrangedSubviews: [
            customGasPriceField,
            customGasField]
            )
        customGasStackView.translatesAutoresizingMaskIntoConstraints = false
        customGasStackView.axis = .vertical
        customGasStackView.distribution = .fillEqually
        customGasStackView.spacing = 0
        return customGasStackView
    }()
    lazy var superSelectLabel: UILabel = {
        let superSelectLabel = UILabel()
        superSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        superSelectLabel.textColor = Colors.textgraycolor
        superSelectLabel.font = UIFont.systemFont(ofSize: 12)
//        superSelectLabel.text = NSLocalizedString("ML.Transaction.cell.Advancedoptions", value: "高级选项", comment: "")
        superSelectLabel.text = "ML.Transaction.cell.Advancedoptions".localized()
        return superSelectLabel
    }()

    lazy var selectControl: UIControl = {
        var selectControl = UIControl()
        selectControl.addTarget(self, action: #selector(selectControlAction(sender:)), for: UIControlEvents.touchUpInside)
        selectControl.translatesAutoresizingMaskIntoConstraints = false
        return selectControl
    }()

    lazy var superSelectControl: UISlider = {
        let superSelectControl = UISlider()
        superSelectControl.translatesAutoresizingMaskIntoConstraints = false
        superSelectControl.minimumValue = 0
        superSelectControl.maximumValue = 1
        superSelectControl.thumbTintColor = Colors.f02e44color
        superSelectControl.minimumTrackTintColor = Colors.f02e44color
        superSelectControl.maximumTrackTintColor = Colors.ccccccolor
        //        superSelectControl.isEnabled = false
        return superSelectControl
    }()
    //下一步
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton.init(type: UIButtonType.custom)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.backgroundColor = Colors.f02e44color
        nextBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        nextBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
//        nextBtn.setTitle(R.string.localizable.next(), for: UIControlState.normal)
        nextBtn.setTitle("ML.Next".localized(), for: UIControlState.normal)
        nextBtn.layer.cornerRadius = 5
        nextBtn.layer.masksToBounds = true
        return nextBtn
    }()

    lazy var minerCostLabel: UILabel = {
        var  minerCostLabel = UILabel()
        minerCostLabel.translatesAutoresizingMaskIntoConstraints = false
        minerCostLabel.textAlignment = .left
        minerCostLabel.textColor = Colors.detailTextgraycolor
        minerCostLabel.font = UIFont.init(name: "PingFang SC", size: 12)
        minerCostLabel.text = "ML.Transaction.cell.MinerCost".localized()
        return minerCostLabel
    }()

    lazy var minerCostImageView: UIImageView = {
        var minerCostImageView = UIImageView()
        minerCostImageView.image = R.image.ml_wallet_eth_icon()
        minerCostImageView.translatesAutoresizingMaskIntoConstraints = false
        return minerCostImageView
    }()
    lazy var minerCostSlider: UISlider = {
        var minerCostSlider = UISlider()
        minerCostSlider.translatesAutoresizingMaskIntoConstraints = false
        minerCostSlider.thumbTintColor = Colors.f02e44color
        minerCostSlider.minimumValue = 1
        minerCostSlider.maximumValue = 60
        minerCostSlider.isUserInteractionEnabled = true
        minerCostSlider.maximumTrackTintColor = Colors.ccccccolor
        minerCostSlider.minimumTrackTintColor = Colors.f02e44color
        return minerCostSlider
    }()

    lazy var lowLabel: UILabel = {
        let lowLabel = UILabel()
        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        lowLabel.textColor = Colors.detailTextgraycolor
//        lowLabel.text = NSLocalizedString("ML.Transaction.cell.slow", value: "慢", comment: "")
        lowLabel.text = "ML.Transaction.cell.slow".localized()
        lowLabel.font = UIFont.init(name: "PingFang SC", size: 12)
        return lowLabel
    }()
    lazy var fastLabel: UILabel = {
        let fastLabel = UILabel()
        fastLabel.translatesAutoresizingMaskIntoConstraints = false
        fastLabel.textColor = Colors.detailTextgraycolor
        fastLabel.text = "ML.Transaction.cell.fast".localized()
        fastLabel.font = UIFont.init(name: "PingFang SC", size: 12)
        return fastLabel
    }()
    lazy var costAmound: UILabel = {
        let costAmound = UILabel()
        costAmound.translatesAutoresizingMaskIntoConstraints = false
        costAmound.textColor = Colors.detailTextgraycolor
        costAmound.font = UIFont.init(name: "PingFang SC", size: 12)
        return costAmound
    }()

    lazy var customGasPriceField: UnderLineTextFiled = {
        var customGasPriceField = UnderLineTextFiled(frame: .zero)
        customGasPriceField.translatesAutoresizingMaskIntoConstraints = false
        customGasPriceField.underLineColor = Colors.textgraycolor
        customGasPriceField.font = UIFont.systemFont(ofSize: 12)
//        customGasPriceField.placeholder = NSLocalizedString("ML.Transaction.cell.CustomGasPrice", value: "Custom Gas Price", comment: "")
        customGasPriceField.placeholder = "ML.Transaction.cell.CustomGasPrice".localized()
        customGasPriceField.textColor = Colors.detailTextgraycolor
        customGasPriceField.delegate = self
        return customGasPriceField
    }()
    lazy var customGasField: UnderLineTextFiled = {
        var customGasField = UnderLineTextFiled(frame: .zero)
        customGasField.translatesAutoresizingMaskIntoConstraints = false
        customGasField.underLineColor = Colors.textgraycolor
        customGasField.font = UIFont.systemFont(ofSize: 12)
//        customGasField.placeholder = NSLocalizedString("ML.Transaction.cell.CustomGas", value: "Custom Gas", comment: "")
        customGasField.placeholder = "ML.Transaction.cell.CustomGas".localized()
        customGasField.textColor = Colors.detailTextgraycolor
        customGasField.delegate = self
        return customGasField
    }()
    lazy var placeholderLabel: UILabel = {
        var placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()
    lazy var sixdataTV: AnimatableTextView = {
        var sixdataTV = AnimatableTextView(frame: .zero)
        sixdataTV.translatesAutoresizingMaskIntoConstraints = false
//        sixdataTV.placeholderText = NSLocalizedString("ML.Transaction.cell.Sixteenbinarydata", value: "Sixteen binary data", comment: "")
        sixdataTV.placeholderText = "ML.Transaction.cell.Sixteenbinarydata".localized()
        sixdataTV.placeholderColor = AppStyle.PingFangSC10.textColor
        sixdataTV.font = AppStyle.PingFangSC12.font
        var placeholderLabelConstraints = [NSLayoutConstraint]()
        sixdataTV.configure(placeholderLabel: placeholderLabel, placeholderLabelConstraints: &placeholderLabelConstraints)
        sixdataTV.delegate = self
        sixdataTV.isEditable = false
        sixdataTV.textColor = AppStyle.PingFangSC12.textColor
        sixdataTV.textAlignment = .left
        //        privateTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        sixdataTV.borderWidth = 1
        sixdataTV.borderColor = AppStyle.PingFangSC10.textColor
        return sixdataTV
    }()
    var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.isScrollEnabled = false
        return scrollView
    }()

    //怎么设置参数
    lazy var howToSetBtn: UIButton = {
        let howToSetBtn = UIButton.init(type: UIButtonType.custom)
        howToSetBtn.translatesAutoresizingMaskIntoConstraints = false
        howToSetBtn.backgroundColor = UIColor.white
        howToSetBtn.setTitleColor(UIColor(hex: "F02E44"), for: .normal)
//        howToSetBtn.setTitle(NSLocalizedString("ML.Transaction.cell.HowToSetParameters？", value: "How to set parameters？", comment: ""), for: .normal)
        howToSetBtn.setTitle("ML.Transaction.cell.HowToSetParameters".localized(), for: .normal)
        howToSetBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 9)
        howToSetBtn.isHidden = true
        howToSetBtn.addTarget(self, action: #selector(howToSetAction(sender:)), for: .touchUpInside)
        return howToSetBtn
    }()
//    advanceTransferUrlStr
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
//        costAmound.text = "0.00044679 ether"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(titleLabel)
        addSubview(scanBtn)
        addSubview(payAddressField)
        addSubview(transferAmountField)
        addSubview(remarksField)
        addSubview(stackView)

        addSubview(superSelectLabel)
        addSubview(superSelectControl)
        addSubview(selectControl)
        addSubview(howToSetBtn)
        addSubview(nextBtn)

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(minerCostLabel)
        contentView.addSubview(minerCostImageView)
        contentView.addSubview(minerCostSlider)
        contentView.addSubview(lowLabel)
        contentView.addSubview(costAmound)
        contentView.addSubview(fastLabel)

        contentView.addSubview(customGasPriceField)
        contentView.addSubview(customGasField)
        contentView.addSubview(sixdataTV)
        contentView.addSubview(customGasStackView)

        //                superSelectControl.addGestureRecognizer(tap)

    }
    override func layoutSubviews() {

        super.layoutSubviews()
        let controWidth: CGFloat = sizeWithText(text: "ML.Transaction.cell.HowToSetParameters".localized() as NSString, font: UIFont.systemFont(ofSize: 9), size: CGSize(width: 200, height: 20)).size.width + 20
        NSLayoutConstraint.activate([

            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: kAutoLayoutHeigth(83) + kStatusBarHeight),
            scanBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            scanBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
            scanBtn.widthAnchor.constraint(equalToConstant: 20),
            scanBtn.heightAnchor.constraint(equalToConstant: 20),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kAutoLayoutHeigth(15)),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
//            stackView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(160)),
            stackView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(140)),
            nextBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            nextBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            nextBtn.heightAnchor.constraint(equalToConstant: 40),
            nextBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -KBottomSafeHeight - kAutoLayoutHeigth(50)),
            superSelectControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            superSelectControl.widthAnchor.constraint(equalToConstant: kAutoLayoutWidth(80)),
            superSelectControl.heightAnchor.constraint(equalToConstant: 1),
            superSelectControl.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: kAutoLayoutHeigth(-50)),

            selectControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            selectControl.widthAnchor.constraint(equalToConstant: kAutoLayoutWidth(80)),
            selectControl.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(60)),
            selectControl.centerYAnchor.constraint(equalTo: superSelectControl.centerYAnchor, constant: 0),
//            selectControl.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: -50),

            superSelectLabel.rightAnchor.constraint(equalTo: superSelectControl.leftAnchor, constant: kAutoLayoutWidth(-11)),
            superSelectLabel.centerYAnchor.constraint(equalTo: superSelectControl.centerYAnchor, constant: 0),

            howToSetBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            howToSetBtn.centerYAnchor.constraint(equalTo: superSelectControl.centerYAnchor, constant: 0),
            howToSetBtn.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(20)),
            howToSetBtn.widthAnchor.constraint(equalToConstant: controWidth),
            ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            scrollView.widthAnchor.constraint(equalToConstant: kScreenW),
            scrollView.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: kAutoLayoutHeigth(-75)),
            scrollView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(210)),

            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalToConstant: 2 * kScreenW),
            contentView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(210)),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0),

            minerCostLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            minerCostLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kAutoLayoutHeigth(0)),

            minerCostImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -kScreenW-25),
            minerCostImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kAutoLayoutHeigth(0)),
            minerCostSlider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            minerCostSlider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -kScreenW-25),
            minerCostSlider.topAnchor.constraint(equalTo: minerCostLabel.bottomAnchor, constant: kAutoLayoutHeigth(20)),
            minerCostSlider.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(16)),

            lowLabel.leftAnchor.constraint(equalTo: minerCostSlider.leftAnchor, constant: 0),
            lowLabel.topAnchor.constraint(equalTo: minerCostSlider.bottomAnchor, constant: kAutoLayoutHeigth(20)),

            costAmound.centerXAnchor.constraint(equalTo: minerCostSlider.centerXAnchor, constant: 0),
            costAmound.topAnchor.constraint(equalTo: minerCostSlider.bottomAnchor, constant: kAutoLayoutHeigth(20)),

            fastLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -kScreenW-25),
            fastLabel.topAnchor.constraint(equalTo: minerCostSlider.bottomAnchor, constant: kAutoLayoutHeigth(20)),
            ])
        scrollView.contentSize = CGSize(width: kScreenW * 2, height: 240)

        NSLayoutConstraint.activate([
            //            customGasPriceField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            //            customGasPriceField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kScreenW + 25),
            //            customGasPriceField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            //            customGasPriceField.heightAnchor.constraint(equalToConstant: 50),
            //            customGasField.topAnchor.constraint(equalTo: customGasPriceField.bottomAnchor, constant: 32),
            //            customGasField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kScreenW + 25),
            //            customGasField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            //            customGasField.heightAnchor.constraint(equalToConstant: 50),

            customGasStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: kAutoLayoutHeigth(0)),
            customGasStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kScreenW + 25),
            customGasStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            customGasStackView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(100)),

            sixdataTV.topAnchor.constraint(equalTo: customGasField.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            sixdataTV.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kScreenW + 25),
            sixdataTV.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            sixdataTV.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(70)),

            ])
    }
    @objc func selectControlAction(sender: UIControl) {
        superSelect = !superSelect

        if superSelect {
            superSelectControl.value = 1
            scrollView.contentOffset = CGPoint.init(x: kScreenW, y: 0)

        } else {
            superSelectControl.value = 0
            scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }
        howToSetBtn.isHidden = !superSelect
    }

    @objc func howToSetAction(sender: UIButton) {
        delegate?.didHowToSetAction()
    }
    func validate() -> NSError? {
        let addressString = payAddressField.text ?? ""
        guard EthereumAddress(string: addressString) != nil else {
            let addressErr = MLErrorType.invalidAddress
            MLProgressHud.showError(error: addressErr as NSError)
            return addressErr as NSError
        }
        guard !"".kStringIsEmpty(transferAmountField.text) else {
            let amountErr = MLErrorType.invalidAmount
            MLProgressHud.showError(error: amountErr as NSError)
            return amountErr as NSError
        }
        return nil
    }
//    func updateSliderCostStr(gasLimit: Double) {
//        let gasPrice: String = (viewModel?.gasPrice?.description)!
//        var gasPriceDouble: Double = Double(gasPrice)!
//        let gasLimit = gasLimit
//        var gasPriceString = gasLimit * gasPriceDouble
//        costAmound.text = NSString.init(format: "%f", gasPriceString) as String
//    }
//    @objc func costSlider(sender: UISlider) {
//        updateSliderCostStr(gasLimit: Double(sender.value))
//    }
    @objc func costSliderDragInside(sender: UISlider) {
        print("costSliderDragInside:%d", sender.value)
    }

    @objc func costSliderDragExit(sender: UISlider) {
        print("costSliderDragExit:%d", sender.value)
    }

    @objc func costSliderTap(sender: UISlider) {
        print("costSliderTap:%d", sender.value)
    }
    @objc func sliderTouchDown(sender: UISlider) {
        superSelectControl.isEnabled = false
    }

    @objc func sliderTouchUp(sender: UISlider) {
        superSelectControl.isEnabled = true
    }

}

extension MLSendView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}
extension MLSendView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        placeholderLabel.isHidden = !textView.text.kStringIsEmpty(textView.text)

    }
    func textViewDidEndEditing(_ textView: UITextView) {

        guard "".judgeSixteenData(hex: textView.text ?? "") else {
            delegate?.invideData()
            return
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
}
extension MLSendView: UIGestureRecognizerDelegate {
}
