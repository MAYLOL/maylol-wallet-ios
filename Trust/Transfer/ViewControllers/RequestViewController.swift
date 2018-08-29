// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import CoreImage
import MBProgressHUD
import StackViewController

class RequestViewController: UIViewController {
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = NSLocalizedString("ML.Token.ReceiptCode", value: "Receipt Code", comment: "")
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
    lazy var grayLine: UIView = {
        var grayLine = UIView()
        grayLine.translatesAutoresizingMaskIntoConstraints = false
        grayLine.backgroundColor = Colors.e6e6e6color
        return grayLine
    }()
    lazy var grayBackView: UIView = {
        let grayBackView = UIView()
        grayBackView.translatesAutoresizingMaskIntoConstraints = false
        grayBackView.backgroundColor = Colors.e6e6e6color
        grayBackView.layer.cornerRadius = 5
        grayBackView.layer.masksToBounds = true
        return grayBackView
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var copyButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("ML.Token.copyAddress", value: "复制收款地址", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: "F02E44")
        button.setTitleColor(Colors.fffffgraycolor, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 15)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.myAddressText
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.textColor = Colors.detailTextgraycolor
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    let viewModel: RequestViewModel
    init(
        viewModel: RequestViewModel
        ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = viewModel.backgroundColor
        changeQRCode(value: 0)
        displayStackViewController()
    }
    private func displayStackViewController() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underDynamicLine)
        contentView.addSubview(addressLabel)
        contentView.addSubview(grayLine)
        contentView.addSubview(grayBackView)
        contentView.addSubview(imageView)
        contentView.addSubview(copyButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: 650),

            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            underDynamicLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 47),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            addressLabel.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 32),
            addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -48),
            grayLine.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 32),
            grayLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            grayLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            grayLine.heightAnchor.constraint(equalToConstant: 1),
            imageView.widthAnchor.constraint(equalToConstant: 225),
            imageView.heightAnchor.constraint(equalToConstant: 225),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: grayLine.bottomAnchor, constant: 45 + 12),

            grayBackView.widthAnchor.constraint(equalToConstant: 250),
            grayBackView.heightAnchor.constraint(equalToConstant: 250),
            grayBackView.centerXAnchor.constraint(equalTo: imageView.layoutGuide.centerXAnchor, constant: 0),
            grayBackView.centerYAnchor.constraint(equalTo: imageView.layoutGuide.centerYAnchor, constant: 0),

            copyButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            copyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            copyButton.widthAnchor.constraint(equalToConstant: 250),
            //            copyButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 650)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        changeQRCode(value: Int(textField.text ?? "0") ?? 0)
    }

    func changeQRCode(value: Int) {
        let string = viewModel.myAddressText

        // EIP67 format not being used much yet, use hex value for now
        // let string = "ethereum:\(account.address.address)?value=\(value)"

        DispatchQueue.global(qos: .userInteractive).async {
            let image = QRGenerator.generate(from: string)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    @objc func copyAddress() {
        UIPasteboard.general.string = viewModel.myAddressText

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = viewModel.addressCopiedText
        hud.hide(animated: true, afterDelay: 1.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
