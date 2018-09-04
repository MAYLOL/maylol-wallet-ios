// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import Result
import TrustCore
import RealmSwift

protocol MLTokensViewControllerDelegate: class {
    func didPressAddToken( in viewController: UIViewController)
    func didSelect(token: TokenObject, in viewController: UIViewController)
    func didRequest(token: TokenObject, in viewController: UIViewController)
}

final class MLTokensViewController: UIViewController {

    fileprivate var viewModel: TokensViewModel

    lazy var header: MLTokensHeaderView = {
        let header = MLTokensHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 215))
        header.addressLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(reciveCoinInfo)))
//        header.frame.size = header.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
        return header
    }()

    lazy var footer: TokensFooterView = {
        let footer = TokensFooterView(frame: .zero)
        footer.textLabel.text = viewModel.footerTitle
        footer.textLabel.font = viewModel.footerTextFont
        footer.textLabel.textColor = viewModel.footerTextColor
        footer.frame.size = footer.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
        footer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(missingToken))
        )
        return footer
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(MLTokenViewCell.self, forCellReuseIdentifier: MLTokenViewCell.identifier)
        tableView.tableHeaderView = header
        tableView.addSubview(refreshControl)
        return tableView
    }()

    let refreshControl = UIRefreshControl()
    weak var delegate: MLTokensViewControllerDelegate?
    var etherFetchTimer: Timer?
    let intervalToETHRefresh = 10.0

    lazy var fetchClosure: () -> Void = {
        return debounce(delay: .seconds(7), action: { [weak self] () in
            self?.viewModel.fetch()
        })
    }()

    init(
        viewModel: TokensViewModel
        ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        sheduleBalanceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(MLTokensViewController.resignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MLTokensViewController.didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTokenObservation()
//        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
//        footer.textLabel.text = viewModel.footerTitle

        fetch(force: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.applyTintAdjustment()
    }

    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        fetch(force: true)
    }

    func fetch(force: Bool = false) {
        if force {
            viewModel.fetch()
        } else {
            fetchClosure()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshHeaderView() {
        header.amountLabel.attributedText = viewModel.headerAttributeBalance
        header.viewModel = viewModel
    }

    @objc func missingToken() {
        delegate?.didPressAddToken(in: self)
    }

    private func startTokenObservation() {
        viewModel.setTokenObservation { [weak self] (changes: RealmCollectionChange) in
            guard let strongSelf = self else { return }
            let tableView = strongSelf.tableView
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                self?.tableView.reloadData()
            case .error: break
            }
            strongSelf.refreshControl.endRefreshing()
            self?.refreshHeaderView()
        }
    }

    @objc func resignActive() {
        etherFetchTimer?.invalidate()
        etherFetchTimer = nil
        stopTokenObservation()
    }

    @objc func didBecomeActive() {
        sheduleBalanceUpdate()
        startTokenObservation()
    }

    private func sheduleBalanceUpdate() {
        guard etherFetchTimer == nil else { return }
        etherFetchTimer = Timer.scheduledTimer(timeInterval: intervalToETHRefresh, target: BlockOperation { [weak self] in
            self?.viewModel.updatePendingTransactions()
        }, selector: #selector(Operation.main), userInfo: nil, repeats: true)
    }

    private func stopTokenObservation() {
        viewModel.invalidateTokensObservation()
    }

    @objc private func reciveCoinInfo() {
        let tokenObject = viewModel.tokens.first
        self.delegate?.didRequest(token: tokenObject!, in: self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        resignActive()
        stopTokenObservation()
    }
}

extension MLTokensViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let token = viewModel.item(for: indexPath)
        delegate?.didSelect(token: token, in: self)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let token = viewModel.item(for: indexPath)
        let deleteAction = UIContextualAction(style: .normal, title: R.string.localizable.transactionsReceiveButtonTitle()) { _, _, handler in
            self.delegate?.didRequest(token: token, in: self)
            handler(true)
        }
        deleteAction.backgroundColor = Colors.lightBlue
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TokensLayout.tableView.height
    }
}
extension MLTokensViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MLTokenViewCell.identifier, for: indexPath) as! MLTokenViewCell
        cell.isExclusiveTouch = true
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tokens.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tokenViewCell = cell as? MLTokenViewCell else { return }
        tokenViewCell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
    }
}
extension MLTokensViewController: TokensViewModelDelegate {
    func refresh() {
        self.tableView.reloadData()
        self.refreshHeaderView()
    }
}
extension MLTokensViewController: Scrollable {
    func scrollOnTop() {
        tableView.scrollOnTop()
    }
}
