//// Copyright DApps Platform Inc. All rights reserved.
//
//import Foundation
//import UIKit
//import TrustKeystore
//
//protocol MLManagerWalletViewDelegate: class {
//    func didSelect(wallet: WalletInfo, account: Account, in controller: UIViewController)
//    func didDeleteAccount(account: WalletInfo, in viewController: UIViewController)
//    func didSelectForInfo(wallet: WalletInfo, account: Account, in controller: UIViewController)
//}
//
//class MLManagerWalletView: UIView {
//
//    lazy var fullView: UIVisualEffectView = {
//        let blur = UIBlurEffect(style:UIBlurEffectStyle.dark)
//        var effecview = UIVisualEffectView(effect: blur)
//        effecview.translatesAutoresizingMaskIntoConstraints = false
//        effecview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        addSubview(effecview)
//        return effecview
//    }()
//    lazy var rightManagerView: UIView = {
//        let managerView = UIView(frame: .zero)
//        managerView.translatesAutoresizingMaskIntoConstraints = false
//        managerView.backgroundColor = UIColor.white
//        return managerView
//    }()
//    lazy var walletsView: UITableView = {
//        let walletsView = UITableView(frame: .zero, style: UITableViewStyle.plain)
//        walletsView.translatesAutoresizingMaskIntoConstraints = false
//        walletsView.backgroundColor = UIColor.white
//        walletsView.register(MLWalletViewCell.self, forCellReuseIdentifier: MLWalletViewCell.identifier)
//        walletsView.delegate = self
//        walletsView.dataSource = self
//        return walletsView
//    }()
//
////    var keystore: Keystore =
////    lazy var viewModel: WalletsViewModel = {
////        let model = WalletsViewModel(keystore: keystore)
////        model.delegate = self
////        return model
////    }()
//
//    func setKeystore(keystore: Keystore) {
//        let model = WalletsViewModel(keystore: keystore)
//        model.delegate = self
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    weak var delegate: MLManagerWalletViewDelegate?
//
////    convenience init(keystore: Keystore,
////         viewController: UIViewController,
////         frame:CGRect) {
////        self.keystore = keystore
////        self.viewController = viewController
////        self.init()
////    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    func fetch() {
//        viewModel.fetchBalances()
//        viewModel.refresh()
//        walletsView.reloadData()
//    }
//    func setup() {
//
//        addSubview(walletsView)
////        rightManagerView.addSubview(walletsView)
//        NSLayoutConstraint.activate([
////            rightManagerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
////            rightManagerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
////            rightManagerView.widthAnchor.constraint(equalToConstant: 0.6 * kScreenW),
////            rightManagerView.rightAnchor.constraint(equalTo: rightManagerView.rightAnchor, constant: 0),
//            ])
//    }
//
//    func start() {
//
//    }
//    func end() {
//
//    }
//
//    func confirmDelete(wallet: WalletInfo) {
//        self.viewController?.confirm(
//            title: NSLocalizedString("accounts.confirm.delete.title", value: "Are you sure you would like to delete this wallet?", comment: ""),
//            message: NSLocalizedString("accounts.confirm.delete.message", value: "Make sure you have backup of your wallet.", comment: ""),
//            okTitle: R.string.localizable.delete(),
//            okStyle: .destructive
//        ) { [weak self] result in
//            switch result {
//            case .success:
//                self?.delete(wallet: wallet)
//            case .failure: break
//            }
//        }
//    }
//
//    func delete(wallet: WalletInfo) {
////        navigationController?.displayLoading(text: R.string.localizable.deleting())
//        keystore.delete(wallet: wallet) { [weak self] result in
//            guard let `self` = self else { return }
////            self.navigationController?.hideLoading()
//            switch result {
//            case .success:
//                self.delegate?.didDeleteAccount(account: wallet, in: self.viewController!)
//            case .failure(let error):
//                self.viewController?.displayError(error: error)
//            }
//        }
//    }
//}
//
//extension MLManagerWalletView: UITableViewDelegate,UITableViewDataSource {
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.walletViewCell.name, for: indexPath) as! WalletViewCell
//        cell.viewModel = viewModel.cellViewModel(for: indexPath)
//        cell.delegate = self
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.numberOfSection
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRows(in: section)
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return viewModel.canEditRowAt(for: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.delete {
//            confirmDelete(wallet: viewModel.cellViewModel(for: indexPath).wallet)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewModel = self.viewModel.cellViewModel(for: indexPath)
//        tableView.deselectRow(at: indexPath, animated: true)
//        delegate?.didSelect(wallet: viewModel.wallet, account: viewModel.account, in: self.viewController!)
//    }
//}
//extension MLManagerWalletView: WalletViewCellDelegate {
//    func didPress(viewModel: WalletAccountViewModel, in cell: WalletViewCell) {
//        delegate?.didSelectForInfo(wallet: viewModel.wallet, account: viewModel.account, in: self.viewController!)
//    }
//}
//
//extension MLManagerWalletView: WalletsViewModelProtocol {
//    func update() {
//        viewModel.refresh()
//        walletsView.reloadData()
//    }
//}
