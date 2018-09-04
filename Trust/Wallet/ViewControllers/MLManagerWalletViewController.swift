// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import TrustCore
import TrustKeystore

protocol MLManagerWalletViewControllerDelegate: class {
    func didDeleteAccount(account: WalletInfo, in viewController: MLManagerWalletViewController)
    func addWallet(entryPoint: WalletEntryPoint, in viewController: MLManagerWalletViewController)
    func didPressWallet(account: WalletInfo, in viewController: MLManagerWalletViewController)
}

class MLManagerWalletViewController: UIViewController {

    let session: WalletSession
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage
    let netWork: NetworkProtocol
    let tokensViewModel: TokensViewModel

    lazy var viewModel: MLWalletsViewModel = {
        let model = MLWalletsViewModel(keystore: keystore)
        model.delegate = self
        return model
    }()
    weak var delegate: MLManagerWalletViewControllerDelegate?

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.text = "ML.Manager.Wallet".localized()
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
    lazy var walletsView: UITableView = {
        let walletsView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        walletsView.translatesAutoresizingMaskIntoConstraints = false
        walletsView.backgroundColor = UIColor.white
        walletsView.register(MLManageWalletViewCell.self, forCellReuseIdentifier: MLManageWalletViewCell.identifier)
        walletsView.delegate = self
        walletsView.dataSource = self
        walletsView.separatorStyle = UITableViewCellSeparatorStyle.none
        return walletsView
    }()
    lazy var buttonsView: ButtonsFooterView = {
        let buttonsView = ButtonsFooterView(
            frame: .zero,
            bottomOffset: 0
        )
        buttonsView.sendButton.setTitle("welcome.createWallet.button.title".localized(), for: UIControlState.normal)
    buttonsView.requestButton.setTitle("welcome.importWallet.button.title".localized(), for: UIControlState.normal)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //        buttonsView.setBottomBorder()
        return buttonsView
    }()
    init(keystore: Keystore,
         session: WalletSession,
         tokensStorage: TokensDataStore,
         transactionsStore: TransactionsStorage,
         netWork: NetworkProtocol,
         tokensViewModel: TokensViewModel) {
        self.keystore = keystore
        self.tokensViewModel = tokensViewModel
        self.session = session
        self.store = tokensStorage
        self.transactionsStore = transactionsStore
        self.netWork = netWork

        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setup()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }

    func fetch() {
        viewModel.fetchBalances()
        viewModel.refresh()
        walletsView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 105),
            underDynamicLine.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 54),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            walletsView.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 25),
            walletsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            walletsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            walletsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -KBottomSafeHeight - 50),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -KBottomSafeHeight),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutGuide.leadingAnchor, constant: 0),
            buttonsView.heightAnchor.constraint(equalToConstant: 50),
            ])
    }

    func setup() {
        view.addSubview(titleLabel)
        view.addSubview(underDynamicLine)
        view.addSubview(walletsView)
        view.addSubview(buttonsView)
        buttonsView.sendButton.addTarget(self, action: #selector(createWalletAction), for: .touchUpInside)
        buttonsView.requestButton.addTarget(self, action: #selector(ImportWalletAction), for: .touchUpInside)

    }

    @objc private func createWalletAction() {
        delegate?.addWallet(entryPoint: .createInstantWallet, in: self)
    }
    @objc private func ImportWalletAction() {
        delegate?.addWallet(entryPoint: .importWallet, in: self)
    }
}

extension MLManagerWalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MLManageWalletViewCell.identifier, for: indexPath) as! MLManageWalletViewCell
        cell.viewModel = viewModel.cellViewModel(for: indexPath)
//        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.viewModel.cellViewModel(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didPressWallet(account: viewModel.cellViewModel(for: indexPath).wallet, in: self)
    }

}
extension MLManagerWalletViewController: MLWalletsViewModelProtocol {
    func update() {
        viewModel.refresh()
        walletsView.reloadData()
    }
}
