// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Localize_Swift

protocol MLWelcomeViewControllerDelegate: class {

    func didPressDismiss(in viewController: MLWelcomeViewController)
    func didDismiss(in viewController: MLWelcomeViewController)
}
class MLWelcomeViewController: UIViewController {

    weak var delegate: MLWelcomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        view.addSubview(guideView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if delegate != nil {
            delegate?.didDismiss(in: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    lazy var guideView: MLGuideView = {
       let guideView = MLGuideView(frame: UIScreen.main.bounds, pages: getGuidePages())
        return guideView
    }()

    private func getGuidePages() -> [UIView] {
        var guidePages: [UIView] = []
        for i in 0...2 {
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = imageArr[i]
            imageView.isUserInteractionEnabled = true
            labelContro(contentV: imageView, i: i)
            guidePages.append(imageView)
        }

        return guidePages
    }

    func labelContro(contentV: UIView, i: Int) {
        if i == 2 {
            let btnWidth: CGFloat = kScreenW - 50
            let kwidth = UIScreen.main.bounds.size.width
            let kheight = UIScreen.main.bounds.size.height

            let Bx: CGFloat = (kwidth - btnWidth) / 2
            let By: CGFloat = (kheight / 2) + 150
            let Bwidth: CGFloat = btnWidth
            let Bheight: CGFloat = 40

            let enterButton = UIButton(frame: CGRect(x: Bx, y: By, width: Bwidth, height: Bheight))
            enterButton.setTitle(titleArr[i], for: UIControlState.normal)
            enterButton.addTarget(self, action: #selector(guideViewHide), for: .touchUpInside)
            enterButton.backgroundColor = UIColor.white
            enterButton.setTitleColor(UIColor.red, for: UIControlState.normal)
            enterButton.layer.cornerRadius = 20
            enterButton.layer.masksToBounds = true
            enterButton.layer.borderColor = UIColor.red.cgColor
            enterButton.layer.borderWidth = 1

            contentV.addSubview(enterButton)
            return
        }

        let titleStrWidth: CGFloat =  kScreenW - 50
        let kwidth = UIScreen.main.bounds.size.width
        let kheight = UIScreen.main.bounds.size.height
        let Lx: CGFloat = (kwidth - titleStrWidth) / 2
        let Ly: CGFloat = (kheight / 2) + 60
        let Lwidth: CGFloat = titleStrWidth
        let Lheight: CGFloat = 30
        let titleLab = UILabel(frame: CGRect(x: Lx, y: Ly, width: Lwidth, height: Lheight))
        titleLab.text = titleArr[i]
        titleLab.font = UIFont .boldSystemFont(ofSize: 25)
        titleLab.textAlignment = .center
        titleLab.numberOfLines = 0
        titleLab.textColor = UIColor.black

        let detailStrWidth: CGFloat =  kScreenW - 50
        let Dx: CGFloat = (kwidth - detailStrWidth) / 2
        let Dy: CGFloat = titleLab.frame.size.height + Ly + 10
        let Dwidth: CGFloat = detailStrWidth
        let Dheight: CGFloat = 60

        let subDetail = UILabel(frame: CGRect(x: Dx, y: Dy, width: Dwidth, height: Dheight))
        subDetail.text = detailArr[i]
        subDetail.numberOfLines = 0
        subDetail.font = UIFont .systemFont(ofSize: 16)
        subDetail.textAlignment = .center
        subDetail.textColor = UIColor.gray
        contentV.addSubview(titleLab)
        contentV.addSubview(subDetail)
    }

    @objc func guideViewHide() {

        if delegate != nil {
            delegate?.didPressDismiss(in: self)
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    lazy var titleArr = ["ML.Lanuch.Page1.Title".localized(), "ML.Lanuch.Page2.Title".localized(), "ML.Lanuch.Page3.Button".localized()]
    lazy var detailArr = ["ML.Lanuch.Page1.detail".localized(), "ML.Lanuch.Page2.detail".localized(), ""]
    lazy var imageArr = [R.image.ml_launchScreen_0Jpg(), R.image.ml_launchScreen_1Jpg(), R.image.ml_launchScreen_2Jpg()]

    private func needShowGuideView() -> Bool {
        return true
    }

}
