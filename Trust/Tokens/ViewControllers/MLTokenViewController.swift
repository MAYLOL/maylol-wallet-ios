// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import StatefulViewController

protocol MLTokenViewControllerDelegate: class {
    func didPressRequest(for token: TokenObject, in controller: UIViewController)
    func didPressSend(for token: TokenObject, in controller: UIViewController)
    func didPressInfo(for token: TokenObject, in controller: UIViewController)
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController)
}

final class MLTokenViewController: UIViewController {

    private let refreshControl = UIRefreshControl()

    private var tableView = TransactionsTableView()

    private lazy var header: MLTokenHeaderView = {
        let view = MLTokenHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: kAutoLayoutHeigth(320)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var buttonsView: ButtonsFooterView = {
        let buttonsView = ButtonsFooterView(
            frame: .zero,
            bottomOffset: 0
        )
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsView.setBottomBorder()
        return buttonsView
    }()
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: header.frame.height + 100, left: 0, bottom: 0, right: 0)
    }

    private var viewModel: TokenViewModel

    weak var delegate: MLTokenViewControllerDelegate?

    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

//        navigationItem.title = viewModel.title
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.tableHeaderView = header
        tableView.register(TransactionViewCell.self, forCellReuseIdentifier: TransactionViewCell.identifier)
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: kNavigationBarHeight + kStatusBarHeight),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(345)),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50-KBottomSafeHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -KBottomSafeHeight),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutGuide.leadingAnchor, constant: 0),
            buttonsView.heightAnchor.constraint(equalToConstant: 50)
            ])

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        buttonsView.requestButton.addTarget(self, action: #selector(request), for: .touchUpInside)
        buttonsView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)

        // TODO: Enable when finished
//        if isDebug {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(infoAction))
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observToken()
        observTransactions()
//        configTableViewStates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialViewState()
        fetch()
        updateHeader()
    }

    private func fetch() {
        startLoading()
        viewModel.fetch()
        print("",viewModel.getModel())

    }

    @objc func infoAction() {
        delegate?.didPressInfo(for: viewModel.token, in: self)
    }

    private func observToken() {
        viewModel.tokenObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.updateHeader()
            self?.endLoading()
        }
    }

    private func observTransactions() {
        viewModel.transactionObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.endLoading()
        }
    }

    private func updateHeader() {
        header.viewModel = viewModel
    }

    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        fetch()
    }

    @objc func send() {
        delegate?.didPressSend(for: viewModel.token, in: self)
    }

    @objc func request() {
        delegate?.didPressRequest(for: viewModel.token, in: self)
    }

    deinit {
        viewModel.invalidateObservers()
    }

    private func configTableViewStates() {
        errorView = ErrorView(insets: insets, onRetry: { [weak self] in
            self?.fetch()
        })
        loadingView = LoadingView(insets: insets)
        emptyView = TransactionsEmptyView(insets: insets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLTokenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as! TransactionViewCell
        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(for: section)
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
////       let sessionView = MLTransactionSessionView(frame: .zero)
//        return sessionView
//
////            SectionHeader(
////            title: viewModel.titleForHeader(in: section)
////        )
//    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return StyleLayout.TableView.heightForHeaderInSection
//        return kAutoLayoutHeigth(50)
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPress(viewModel: viewModel, transaction: viewModel.item(for: indexPath.row, section: indexPath.section), in: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MLTokenViewController: StatefulViewController {
    func hasContent() -> Bool {
        return viewModel.hasContent()
    }
}
