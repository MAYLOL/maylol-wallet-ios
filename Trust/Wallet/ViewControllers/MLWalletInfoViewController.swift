// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustKeystore

protocol MLWalletInfoViewControllerDelegate: class {
    func didCancel()
    func didAction(action: ManagerActionType, wallet: WalletInfo)
    func didPreseSave(wallet: WalletInfo, fields: [WalletInfoField], controller:MLWalletInfoViewController)
    func didDeleteAccount(account: WalletInfo, in viewController: MLWalletInfoViewController)
}
enum MLWalletInfoField {
    case name(String)
    case backup(Bool)
    case mainWallet(Bool)
    case balance(String)
}
class MLWalletInfoViewController: UIViewController {

    weak var delegate: MLWalletInfoViewControllerDelegate?
    let wallet: WalletInfo
    let keystore: Keystore
    lazy var viewModel: MLWalletInfoViewModel = {
        return MLWalletInfoViewModel(wallet: wallet)
    }()

    lazy var header: MLWalletInfoHeaderView = {
        let header = MLWalletInfoHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        header.translatesAutoresizingMaskIntoConstraints = false
//        header.addressLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(reciveCoinInfo)))
        return header
    }()
    lazy var walletsView: UITableView = {
        let walletsView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        walletsView.translatesAutoresizingMaskIntoConstraints = false
        walletsView.backgroundColor = UIColor.white
        walletsView.register(MLWalletInfoCell.self, forCellReuseIdentifier: MLWalletInfoCell.identifier)
        walletsView.register(MLWalletInfoWalletNameCell.self, forCellReuseIdentifier: MLWalletInfoWalletNameCell.identifier)
        walletsView.delegate = self
        walletsView.dataSource = self
        walletsView.bounces = false
//        walletsView.tableHeaderView = header
        walletsView.separatorStyle = UITableViewCellSeparatorStyle.none
        return walletsView
    }()

    lazy var backUpBtn: UIButton = {
        let backUpBtn = UIButton.init(type: UIButtonType.custom)
        backUpBtn.translatesAutoresizingMaskIntoConstraints = false
        backUpBtn.backgroundColor = UIColor(hex: "F02E44")
        backUpBtn.setTitleColor(Colors.fffffgraycolor, for: .normal)
        backUpBtn.setTitle("ML.BackupPhrase".localized(), for: .normal)
        backUpBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        backUpBtn.layer.cornerRadius = 5
        backUpBtn.layer.masksToBounds = true

        backUpBtn.addTarget(self, action: #selector(backUpWalletAction(sender:)), for: .touchUpInside)
        return backUpBtn
    }()
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init(type: UIButtonType.custom)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.backgroundColor = Colors.f0f0f0color
        deleteBtn.setTitleColor(Colors.f969696color, for: .normal)
        deleteBtn.setTitle("ML.Manager.DeleteWallet.Title".localized(), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.layer.masksToBounds = true
        deleteBtn.addTarget(self, action: #selector(deleteWalletAction(sender:)), for: .touchUpInside)
        return deleteBtn
    }()

    func addSaveBtn() -> UIButton {
        let saveBtn = UIButton(type: UIButtonType.custom)
        saveBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveBtn.setTitle("ML.Save".localized(), for: UIControlState.normal)
        saveBtn.setTitleColor(Colors.f02e44color, for: UIControlState.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveBtn.addTarget(self, action: #selector(save), for: UIControlEvents.touchUpInside)
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
        wallet: WalletInfo,
        keystore: Keystore
        ) {
        self.wallet = wallet
        self.keystore = keystore
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addSaveBtn())
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
        self.backUpBtn.isHidden = wallet.info.completedBackup
        setup()
        header.viewModel = viewModel
    }
    func setup() {
        view.addSubview(header)
        view.addSubview(walletsView)
        view.addSubview(backUpBtn)
        view.addSubview(deleteBtn)
    }
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: kNavigationBarHeight + kStatusBarHeight + 40),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.heightAnchor.constraint(equalToConstant: 100),
            walletsView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            walletsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            walletsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            walletsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -KBottomSafeHeight-100),
            deleteBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            deleteBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            deleteBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -KBottomSafeHeight-10),
            deleteBtn.heightAnchor.constraint(equalToConstant: 40),

            backUpBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            backUpBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            backUpBtn.bottomAnchor.constraint(equalTo: deleteBtn.topAnchor, constant: -7),
            backUpBtn.heightAnchor.constraint(equalToConstant: 40),
            ])
    }
    @objc func save() {
        let cell = walletsView.cellForRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath) as! MLWalletInfoWalletNameCell
        let name = cell.nameField.text ?? ""
        guard  "".isWalletName(walletName: name) else {
            MLProgressHud.show(message: MLErrorType.WalletNameError.errorDescription!)
            return
        }
        delegate?.didPreseSave(wallet: wallet, fields: [.name(name)], controller: self)
    }
    @objc func dismissViewController() {
        delegate?.didCancel()
    }

    @objc func backUpWalletAction(sender: UIButton) {
//        delegate?.didAction(action: .backsupMnemonic, wallet: wallet)
        confirmPassWord(address: wallet.currentAccount.address.description) { [weak self] result in
            switch result {
            case .success:
                self?.exportMnemonic(for: (self?.wallet.currentAccount.wallet!)!)
            case .failure: break
            }
        }
    }
    @objc func deleteWalletAction(sender: UIButton) {
        confirmDelete(wallet: wallet)
    }
    func confirmDelete(wallet: WalletInfo) {
//        confirm(
//            title: NSLocalizedString("accounts.confirm.delete.title", value: "Are you sure you would like to delete this wallet?", comment: ""),
//            message: NSLocalizedString("accounts.confirm.delete.message", value: "Make sure you have backup of your wallet.", comment: ""),
//            okTitle: R.string.localizable.delete(),
//            okStyle: .destructive
//        ) { [weak self] result in
//            switch result {
//            case .success:
//            self?.delete(wallet: wallet)
//            case .failure: break
//            }
//        }
        confirmPassWord(address: wallet.currentAccount.address.description) { [weak self] result in
            switch result {
            case .success:
                self?.delete(wallet: wallet)
            case .failure: break
            }
        }
    }

    func delete(wallet: WalletInfo) {
        navigationController?.displayLoading(text: "Deleting".localized())
        keystore.delete(wallet: wallet) { [weak self] result in
            guard let `self` = self else { return }
            self.navigationController?.hideLoading()
            switch result {
            case .success:
                self.delegate?.didDeleteAccount(account: wallet, in: self)
            case .failure(let error):
                self.displayError(error: error)
            }
        }
    }

    func exportMnemonic(for account: Wallet) {
//        navigationController.topViewController?.displayLoading()
        self.displayLoading()
        keystore.exportMnemonic(wallet: account) { [weak self] result in
//            self?.navigationController.topViewController?.hideLoading()
            self?.hideLoading()
            switch result {
            case .success(let words):
                self?.exportMnemonicCoordinator(for: account, words: words)
            case .failure(let error):
//                self?.navigationController.topViewController?.displayError(error: error)
                self?.displayError(error: error)
            }
        }
    }
    func exportMnemonicCoordinator(for account: Wallet, words: [String]) {
        let controller = DarkPassphraseViewController(
            account: account,
            words: words,
            mode: .showAndVerify
        )
        controller.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MLWalletInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        let nameCell = tableView.dequeueReusableCell(withIdentifier: MLWalletInfoWalletNameCell.identifier, for: indexPath) as! MLWalletInfoWalletNameCell
            nameCell.titleLabel.text = viewModel.titles[indexPath.row] as String
            nameCell.nameField.text = viewModel.title
            return nameCell
        }
        let nomalCell = tableView.dequeueReusableCell(withIdentifier: MLWalletInfoCell.identifier, for: indexPath) as! MLWalletInfoCell
            nomalCell.titleLabel.text = viewModel.titles[indexPath.row] as String
        return nomalCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //        return viewModel.canEditRowAt(for: indexPath)
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else {
            if viewModel.action[indexPath.row] == .outputPrivate {
                confirmPassWord(address: wallet.currentAccount.address.description) { [weak self] result in
                    switch result {
                    case .success:
                        self?.delegate?.didAction(action: (self?.viewModel.action[indexPath.row])!, wallet: (self?.wallet)!)
                    case .failure: break
                    }
                }
                return
            }
            delegate?.didAction(action: viewModel.action[indexPath.row], wallet: wallet)
            return
        }
    }
}
extension MLWalletInfoViewController: PassphraseViewControllerDelegate {
    func didPressVerify(in controller: PassphraseViewController, with account: Wallet, words: [String]) {
        delegate?.didPreseSave(wallet: wallet, fields: [.backup(true)], controller: self)
    }

    func pushDone(in controller: PassphraseViewController, with account: Wallet) {
        delegate?.didCancel()
    }
}
