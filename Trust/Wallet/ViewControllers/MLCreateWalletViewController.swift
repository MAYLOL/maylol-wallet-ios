// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import MBProgressHUD

protocol MLCreateWalletViewControllerDelegate: class {
    func didPressCreateWallet(in viewController: MLCreateWalletViewController, createWalletViewModel: CreateWalletViewModel)

    func didPressImportWallet(in viewController: MLCreateWalletViewController)

}

final class MLCreateWalletViewController: UIViewController {

    var viewModel = WelcomeViewModel()
    weak var delegate: MLCreateWalletViewControllerDelegate?

    var createWalletView: MLCreateWalletView = {
        let createWalletView = MLCreateWalletView(frame: .zero)
        createWalletView.translatesAutoresizingMaskIntoConstraints = false
        return createWalletView
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewHeight: CGFloat  = createWalletView.calculationheight()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            createWalletView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            createWalletView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            createWalletView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            createWalletView.heightAnchor.constraint(equalToConstant: viewHeight),

            ])
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: viewHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createWalletView.delegate = self
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.addSubview(createWalletView)

    }

    lazy var hud: MBProgressHUD = {
        var hud = MBProgressHUD(view: self.view)
        hud.backgroundColor = UIColor .green
        hud.backgroundView.alpha = 0.5
        hud.isSquare = true
        self.view.addSubview(hud)
        hud.mode = .customView
        let screenCaptureView = MLScreenCaptureView(frame: CGRect(x: 0, y: 0, width: 250, height: 204))
        screenCaptureView.translatesAutoresizingMaskIntoConstraints = false
        hud.customView = screenCaptureView
        return hud
    }()


    //    lazy var screenCaptureView: MLScreenCaptureView = {
    //
    //        return screenCaptureView
    //    }()
}

extension MLCreateWalletViewController: MLCreateWalletViewDelegate {

    func didPressCreateWallet(createWalletViewModel: CreateWalletViewModel) {
        delegate?.didPressCreateWallet(in: self, createWalletViewModel: createWalletViewModel)
    }
    func didPressImportWallet() {
        delegate?.didPressImportWallet(in: self)
    }

    func didPressServise() {
        //        hud.show(animated: true)
        //        print("hud",hud)
        //        MLProgressHud.ShowPrintScreenTips(view: screenCaptureView)
    }
}

extension MLCreateWalletViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        createWalletView.reset()
    }
}
extension MLCreateWalletViewController: MLScreenCaptureViewDelegate {
    func yeeAction() {
        //        hud.hide(animated: true)
    }
}
