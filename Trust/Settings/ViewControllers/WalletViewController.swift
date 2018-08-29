// Copyright DApps Platform Inc. All rights reserved.

import UIKit

enum DetailsViewType: Int {
    case tokens
    case nonFungibleTokens
}

class WalletViewController: UIViewController {
    fileprivate lazy var segmentController: UISegmentedControl = {
        let items = [
            R.string.localizable.tokens(),
            R.string.localizable.collectibles(),
        ]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = DetailsViewType.tokens.rawValue
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.blue]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setDividerImage(UIImage.filled(with: UIColor.white), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        for selectView in segmentedControl.subviews {
            selectView.tintColor = UIColor.white
        }
        return segmentedControl
    }()
    var tokensViewController: MLTokensViewController
    var nonFungibleTokensViewController: NonFungibleTokensViewController

    init(
        tokensViewController: MLTokensViewController,
        nonFungibleTokensViewController: NonFungibleTokensViewController
    ) {
        self.tokensViewController = tokensViewController
        self.nonFungibleTokensViewController = nonFungibleTokensViewController
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.titleView = segmentController
        setupView()
//        ml_wallet_home_btnmenu
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: R.image.ml_wallet_home_btnmenu(), style: .plain, target: self, action: #selector(showMenuList))
    }

    private func setupView() {
        updateView()
    }

    private func updateView() {
        showBarButtonItems()
        add(asChildViewController: tokensViewController)
//          self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: R.image.ml_wallet_btn_return(), style: .plain, target: self, action: #selector(dismiss(animated:completion:)))
//        if segmentController.selectedSegmentIndex == DetailsViewType.tokens.rawValue {
//            showBarButtonItems()
//            remove(asChildViewController: nonFungibleTokensViewController)
//            add(asChildViewController: tokensViewController)
//        } else {
//            hideBarButtonItems()
//            remove(asChildViewController: tokensViewController)
//            add(asChildViewController: nonFungibleTokensViewController)
//        }
    }

//    @objc func showMenuList() {
//
//    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func showBarButtonItems() {
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
//        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }

    private func hideBarButtonItems() {
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
//        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletViewController: Scrollable {
    func scrollOnTop() {
        switch segmentController.selectedSegmentIndex {
        case DetailsViewType.tokens.rawValue:
            tokensViewController.tableView.scrollOnTop()
        case DetailsViewType.nonFungibleTokens.rawValue:
            nonFungibleTokensViewController.tableView.scrollOnTop()
        default:
            break
        }
    }
}
