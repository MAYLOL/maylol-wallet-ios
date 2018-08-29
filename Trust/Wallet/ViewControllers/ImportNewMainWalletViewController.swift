// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Eureka
import TrustCore
protocol ImportNewMainWalletViewControllerDelegate: class {
    func didImportAccount(account: WalletInfo, fields: [WalletInfoField], in viewController: ImportNewMainWalletViewController, password: String)
}
class ImportNewMainWalletViewController: UIViewController {

    weak var delegate: ImportNewMainWalletViewControllerDelegate?
    let keystore: Keystore
    let coin: Coin
    private lazy var viewModel: ImportWalletViewModel = {
        return ImportWalletViewModel(coin: coin)
    }()
    var importSelectionType: ImportSelectionType = .mnemonic
    lazy var switchHeaderView: MLImportSwitchHeaderView = {
        var switchHeaderView = MLImportSwitchHeaderView(frame: .zero)
        switchHeaderView.translatesAutoresizingMaskIntoConstraints = false
        switchHeaderView.delegate = self
        return switchHeaderView
    }()
    lazy var phraseView: MLImportPhraseView = {
        var phraseView = MLImportPhraseView(frame: .zero)
        phraseView.translatesAutoresizingMaskIntoConstraints = false
        return phraseView
    }()
    lazy var privateView: MLImportPrivateView = {
        var privateView = MLImportPrivateView(frame: .zero)
        privateView.translatesAutoresizingMaskIntoConstraints = false
        return privateView
    }()

    lazy var importBtn: UIButton = {
        let importBtn = UIButton.init(type: UIButtonType.custom)
        importBtn.translatesAutoresizingMaskIntoConstraints = false
        importBtn.backgroundColor = UIColor(hex: "F02E44")
        importBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        importBtn.setTitle(R.string.localizable.welcomeImportWalletButtonTitle(), for: .normal)
        importBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        importBtn.layer.cornerRadius = 5
        importBtn.layer.masksToBounds = true

        importBtn.addTarget(self, action: #selector(importWalletAction(sender:)), for: .touchUpInside)
        return importBtn
    }()

    lazy var introduceBtn: UIButton = {
        let introduceBtn = UIButton(type: UIButtonType.custom)
        introduceBtn.translatesAutoresizingMaskIntoConstraints = false
        introduceBtn.backgroundColor = UIColor.white
        introduceBtn.setTitleColor(UIColor(hex: "F02E44"), for: .normal)
        introduceBtn.setTitle(R.string.localizable.mlPrivateIntroduce(), for: .normal)
        //        R.string.localizable.mlPhraseIntroduce()
        introduceBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        introduceBtn.layer.cornerRadius = 5
        introduceBtn.layer.masksToBounds = true
        introduceBtn.addTarget(self, action: #selector(introduceAction(sender:)), for: .touchUpInside)
        return introduceBtn
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    init(
        keystore: Keystore,
        for coin: Coin
        ) {
        self.keystore = keystore
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(switchHeaderView)
        NSLayoutConstraint.activate([
            switchHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100 - kStatusBarHeight),
            switchHeaderView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            switchHeaderView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            switchHeaderView.heightAnchor.constraint(equalToConstant: switchHeaderView.calculationheight()),
            ])
        addPhraseView()
        self.view.addSubview(importBtn)
        self.view.addSubview(introduceBtn)
        NSLayoutConstraint.activate([
            importBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 472.5),
            importBtn.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            importBtn.widthAnchor.constraint(equalToConstant: 135),
            importBtn.heightAnchor.constraint(equalToConstant: 40),
            introduceBtn.topAnchor.constraint(equalTo: importBtn.bottomAnchor, constant: 75),
            introduceBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            introduceBtn.widthAnchor.constraint(equalToConstant: 160),
            introduceBtn.heightAnchor.constraint(equalToConstant: 40),
            ])
        let viewHeight: CGFloat  = calculationheight()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: viewHeight),
            ])
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: viewHeight)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func calculationheight() -> CGFloat {

        return 472.5 + 75 + 80 + 20

    }
    @objc private func introduceAction(sender: UIButton){
        if sender.titleLabel?.text == NSLocalizedString("MLPhraseIntroduce", value: "什么是助记词？", comment: "") {
            print("什么是助记词？")
        } else {
            print("什么是私钥？")
        }
    }
    @objc private func importWalletAction(sender: UIButton){

        let initialName = WalletInfo.initialName(index: keystore.wallets.count)
        switch importSelectionType {
        case .mnemonic:
            if phraseView.observeStatus() {
                let phraseInput = phraseView.getPhraseWord()
                let words = phraseInput.components(separatedBy: " ").map { $0.trimmed.lowercased() }
                let password = phraseView.getPassWord()
                displayLoading(text: NSLocalizedString("importWallet.importingIndicator.label.title", value: "Importing wallet...", comment: ""), animated: false)
                //                let type = ImportSelectionType(title: switchHeaderView.getTitle())
                let importType: ImportType = .mnemonic(words: words, password:"", derivationPath: coin.derivationPath(at: 0))
                keystore.importWallet(type: importType, coin: coin) { result in
                    self.hideLoading(animated: false)
                    switch result {
                    case .success(let account):
                        self.didImport(account: account, name: initialName, password: password)
                    case .failure(let error):
                        self.displayError(error: error)
                    }
                }
            }else{
                return
            }
            break
        case .privateKey:
            if privateView.observeStatus() {
                let privateKeyInput = privateView.getPrivateWord()
                let password = privateView.getPassWord()
                displayLoading(text: NSLocalizedString("importWallet.importingIndicator.label.title", value: "Importing wallet...", comment: ""), animated: false)
                //                let type = ImportSelectionType(title: switchHeaderView.getTitle())
                let importType: ImportType = .privateKey(privateKey: privateKeyInput)
                keystore.importWallet(type: importType, coin: coin) { result in
                    self.hideLoading(animated: false)
                    switch result {
                    case .success(let account):
                        self.didImport(account: account, name: initialName, password: password)
                    case .failure(let error):
                        self.displayError(error: error)
                    }
                }
            }else{
                return
            }
            break
        default:
            return
        }
    }
    func didImport(account: WalletInfo, name: String, password: String) {
        delegate?.didImportAccount(account: account, fields: [
            .name(name),
            .backup(true),
            ], in: self, password: password)
    }
    func switchImportStyle(importSelectType: ImportSelectionType) {
        importSelectionType = importSelectType
        switch importSelectionType {
        case .mnemonic:
            importSelectionType = .mnemonic
            removePrivateInfo()
            addPhraseView()
            break
        case .privateKey:
            importSelectionType = .privateKey
            removePhraseInfo()
            addPrivateView()
            break
        case .keystore:
            break
        case .address:
            break
        }
    }

    func addPhraseView() {
        //        R.string.localizable.mlPhraseIntroduce()
        introduceBtn.setTitle(NSLocalizedString("MLPhraseIntroduce", value: "什么是助记词？", comment: ""), for: .normal)
        self.view.addSubview(phraseView)
        NSLayoutConstraint.activate([
            phraseView.topAnchor.constraint(equalTo: switchHeaderView.bottomAnchor, constant: 15),
            phraseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            phraseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            phraseView.heightAnchor.constraint(equalToConstant: phraseView.calculationheight()),
            ])
    }

    func addPrivateView() {
        //R.string.localizable.mlPrivateIntroduce()
        introduceBtn.setTitle(NSLocalizedString("MLPrivateIntroduce", value: "什么是私钥？", comment: ""), for: .normal)
        self.view.addSubview(privateView)
        NSLayoutConstraint.activate([
            privateView.topAnchor.constraint(equalTo: switchHeaderView.bottomAnchor, constant: 15),
            privateView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            privateView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            privateView.heightAnchor.constraint(equalToConstant: phraseView.calculationheight()),
            ])
    }

    func removePhraseInfo() {
        phraseView.removeFromSuperview()
    }

    func removePrivateInfo() {
        privateView.removeFromSuperview()
    }

}

extension ImportNewMainWalletViewController: MLImportSwitchHeaderViewDelegate {

    func didSwitchImportStyle(importSelectionType: ImportSelectionType) {
        switchImportStyle(importSelectType: importSelectionType)
    }

}

extension WalletInfo {
    static var emptyName: String {
//        return "Unnamed " + R.string.localizable.wallet()
        return "ML.Manager.UnnamedWallet".localized()
    }

    static func initialName(index numberOfWallets: Int) -> String {
        if numberOfWallets == 0 {
//            return R.string.localizable.mainWallet()
            return "MainWallet".localized()
        }
//        return String(format: "%@ %@", R.string.localizable.wallet(), "\(numberOfWallets + 1)"
        return String(format: "%@ %@", "Wallet".localized(), "\(numberOfWallets + 1)"
        )
    }
}

