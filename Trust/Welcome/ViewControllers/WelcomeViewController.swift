// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import MBProgressHUD

protocol WelcomeViewControllerDelegate: class {
    func didPressCreateWallet(in viewController: WelcomeViewController, createWalletViewModel: CreateWalletViewModel)

    func didPressImportWallet(in viewController: WelcomeViewController)

}

final class WelcomeViewController: UIViewController {

    var viewModel = WelcomeViewModel()
    weak var delegate: WelcomeViewControllerDelegate?

    var wellcomeView: WelcomeView = {
        let wellcomeView = WelcomeView(frame: .zero)
        wellcomeView.translatesAutoresizingMaskIntoConstraints = false
        return wellcomeView
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewHeight: CGFloat  = wellcomeView.calculationheight()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wellcomeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            wellcomeView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            wellcomeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            wellcomeView.heightAnchor.constraint(equalToConstant: viewHeight),

            ])
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: viewHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        wellcomeView.delegate = self
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.addSubview(wellcomeView)

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

extension WelcomeViewController: WelcomeViewDelegate {

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

extension WelcomeViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        wellcomeView.reset()
    }
}
extension WelcomeViewController: MLScreenCaptureViewDelegate {
    func yeeAction() {
//        hud.hide(animated: true)
    }
}
