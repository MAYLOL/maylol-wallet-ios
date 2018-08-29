// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import TrustKeystore

protocol MLManagerWalletViewControllerDelegate: class {
    func didSelect(wallet: WalletInfo, account: Account, in controller: MLManagerWalletViewController)
    func didDeleteAccount(account: WalletInfo, in viewController: MLManagerWalletViewController)
    func didSelectForInfo(wallet: WalletInfo, account: Account, in controller: MLManagerWalletViewController)
    func didPresentVC(pushType: MLPushType)
    func didVDismissView()
    func didGoSettingVC(pushType: MLPushType)
}

class MLManagerWalletViewController: UIViewController {
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
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        effecview.contentView.addGestureRecognizer(tap)
        return effecview
    }()
    lazy var rightManagerView: UIView = {
        let managerView = UIView(frame: .zero)
        //        managerView.translatesAutoresizingMaskIntoConstraints = false
        managerView.backgroundColor = UIColor.white
        return managerView
    }()
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel(frame: .zero)
        titleLabel.font = AppStyle.PingFangSC15.font
        titleLabel.textColor = AppStyle.PingFangSC15.textColor
//        titleLabel.text = NSLocalizedString("ML.Manager.Wallet", value: "管理钱包", comment: "")
        titleLabel.text = "ML.Manager.Wallet".localized()
        titleLabel.font = AppStyle.PingFangSC18.font
        titleLabel.textColor = AppStyle.PingFangSC18.textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    lazy var walletsView: UITableView = {
        let walletsView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        walletsView.translatesAutoresizingMaskIntoConstraints = false
        walletsView.backgroundColor = UIColor.white
        walletsView.register(MLWalletViewCell.self, forCellReuseIdentifier: MLWalletViewCell.identifier)
        walletsView.delegate = self
        walletsView.dataSource = self
        walletsView.separatorStyle = UITableViewCellSeparatorStyle.none
        return walletsView
    }()
    lazy var settingView: UITableView = {
        let settingView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.backgroundColor = UIColor.white
        settingView.register(MLWalletSettingCell.self, forCellReuseIdentifier: MLWalletSettingCell.identifier)
        settingView.bounces = false
        settingView.isScrollEnabled = false
        settingView.showsVerticalScrollIndicator = false
        settingView.delegate = self
        settingView.dataSource = self
        settingView.separatorStyle = UITableViewCellSeparatorStyle.none
        return settingView
    }()
    lazy var settingBtn: UIButton = {
        let settingBtn = UIButton.init(type: UIButtonType.custom)
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
//        settingBtn.setTitle(R.string.localizable.settingsNavigationTitle(), for: .normal)
        settingBtn.setTitle("settings.navigation.title".localized(), for: .normal)
        settingBtn.titleLabel?.font = AppStyle.PingFangSC18.font
        settingBtn.setTitleColor(AppStyle.PingFangSC18.textColor, for: .normal)
        settingBtn.addTarget(self, action: #selector(settingAction(sender:)), for: .touchUpInside)
        settingBtn.setImage(R.image.ml_wallet_menu_btn_setup(), for: .normal)
        settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5)
        settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        return settingBtn
    }()
    weak var delegate: MLManagerWalletViewControllerDelegate?
    let keystore: Keystore
    lazy var viewModel: WalletsViewModel = {
        let model = WalletsViewModel(keystore: keystore)
        model.delegate = self
        return model
    }()

    let mlsettingModel = MLWalletSettingViewModel()

    init(keystore: Keystore) {
        self.keystore = keystore
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fetch() {
        viewModel.fetchBalances()
        viewModel.refresh()
        walletsView.reloadData()
        settingView.reloadData()
    }

    func setup() {
        view.addSubview(fullView)
        fullView.contentView.addSubview(fullView2)
        view.addSubview(rightManagerView)
        rightManagerView.addSubview(titleLabel)
        rightManagerView.addSubview(walletsView)
        rightManagerView.addSubview(settingView)
        rightManagerView.addSubview(settingBtn)
        self.rightManagerView.frame = CGRect(x: kScreenW, y: 0, width: 0.6 * kScreenW, height: kScreenH!)
        NSLayoutConstraint.activate([
            fullView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            fullView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            fullView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            fullView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            fullView2.topAnchor.constraint(equalTo: fullView.topAnchor, constant: 0),
            fullView2.bottomAnchor.constraint(equalTo: fullView.bottomAnchor, constant: 0),
            fullView2.leftAnchor.constraint(equalTo: fullView.leftAnchor, constant: 0),
            fullView2.rightAnchor.constraint(equalTo: fullView.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: rightManagerView.topAnchor, constant: 65),
            titleLabel.leftAnchor.constraint(equalTo: rightManagerView.leftAnchor, constant: 37),
            walletsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kAutoLayoutHeigth(52)),
            walletsView.leftAnchor.constraint(equalTo: rightManagerView.leftAnchor, constant: 37),
            walletsView.rightAnchor.constraint(equalTo: rightManagerView.rightAnchor, constant: -25),
            walletsView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(188)),
            settingView.topAnchor.constraint(equalTo: walletsView.bottomAnchor, constant: 5),
            settingView.leftAnchor.constraint(equalTo: rightManagerView.leftAnchor, constant: 37),
            settingView.rightAnchor.constraint(equalTo: rightManagerView.rightAnchor, constant: -25),
            settingView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(150)),
            settingBtn.bottomAnchor.constraint(equalTo: rightManagerView.bottomAnchor, constant: kAutoLayoutHeigth(-63)),
            settingBtn.rightAnchor.constraint(equalTo: rightManagerView.rightAnchor, constant: -20),
            settingBtn.widthAnchor.constraint(equalToConstant: 100),
            settingBtn.heightAnchor.constraint(equalToConstant: 30),
            ])
    }

    func start() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rightManagerView.frame = CGRect(x: 0.4 * kScreenW, y: 0, width: 0.6 * kScreenW, height: kScreenH!)
        }) {(_ Bool) in
        }
    }
    func end(closure:@escaping ()->()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.rightManagerView.frame = CGRect(x: kScreenW, y: 0, width: 0.6 * kScreenW, height: kScreenH!)
        }) { (_ Bool) in
            closure()
        }
    }

    @objc private func dismissView() {
        delegate?.didVDismissView()
    }
    @objc private func settingAction(sender: UIButton) {
        delegate?.didGoSettingVC(pushType: MLPushType.Setting)
    }
    func confirmDelete(wallet: WalletInfo) {
        self.confirm(
            title: NSLocalizedString("accounts.confirm.delete.title", value: "Are you sure you would like to delete this wallet?", comment: ""),
            message: NSLocalizedString("accounts.confirm.delete.message", value: "Make sure you have backup of your wallet.", comment: ""),
            okTitle: R.string.localizable.delete(),
            okStyle: .destructive
        ) { [weak self] result in
            switch result {
            case .success:
                self?.delete(wallet: wallet)
            case .failure: break
            }
        }
    }

    func delete(wallet: WalletInfo) {
        navigationController?.displayLoading(text: R.string.localizable.deleting())
        keystore.delete(wallet: wallet) { [weak self] result in
            guard let `self` = self else { return }
            self.navigationController?.hideLoading()
            switch result {
            case .success:
                self.delegate?.didDeleteAccount(account: wallet, in: self.toViewController() as! MLManagerWalletViewController)
            case .failure(let error):
                self.displayError(error: error)
            }
        }
    }
}
extension MLManagerWalletViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == walletsView {
            let cell: MLWalletViewCell = tableView.dequeueReusableCell(withIdentifier: MLWalletViewCell.identifier, for: indexPath) as! MLWalletViewCell
            cell.viewModel = viewModel.cellViewModel(for: indexPath)
            //        cell.delegate = self
            return cell
        }
        let cell: MLWalletSettingCell = tableView.dequeueReusableCell(withIdentifier: MLWalletSettingCell.identifier, for: indexPath) as! MLWalletSettingCell
        cell.settingModel = mlsettingModel.getModel(i: indexPath.row)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == walletsView {
            return viewModel.numberOfSection
        }
        return mlsettingModel.session
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == walletsView {
            return viewModel.numberOfRows(in: section)
        }
        return mlsettingModel.row
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == walletsView {
            return viewModel.canEditRowAt(for: indexPath)
        }
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == walletsView {
            if editingStyle == UITableViewCellEditingStyle.delete {
                confirmDelete(wallet: viewModel.cellViewModel(for: indexPath).wallet)
            }
            return
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if tableView == walletsView {
        let viewModel = self.viewModel.cellViewModel(for: indexPath)
            delegate?.didSelect(wallet: viewModel.wallet, account: viewModel.account, in: self.toViewController() as! MLManagerWalletViewController)
            return
        }
        delegate?.didPresentVC(pushType: self.mlsettingModel.pushTypes[indexPath.row])
    }
}
extension MLManagerWalletViewController: MLWalletViewCellDelegate {
    func didPress(viewModel: WalletAccountViewModel, in cell: MLWalletViewCell) {
        delegate?.didSelectForInfo(wallet: viewModel.wallet, account: viewModel.account, in: self.toViewController() as! MLManagerWalletViewController)
    }
    
    //    func didPress(viewModel: WalletAccountViewModel, in cell: WalletViewCell) {
    //        delegate?.didSelectForInfo(wallet: viewModel.wallet, account: viewModel.account, in: self.toViewController())
    //    }
}

extension MLManagerWalletViewController: WalletsViewModelProtocol {
    func update() {
        viewModel.refresh()
        walletsView.reloadData()
        settingView.reloadData()
    }
}
