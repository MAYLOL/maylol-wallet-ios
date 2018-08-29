// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

protocol MLAboutUsViewControllerDelegate: class {
        func didAction(action: MLPushType, in viewController: MLAboutUsViewController)
}

class MLAboutUsViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.text = NSLocalizedString("ML.Setting.cell.Aboutus", value: "About us", comment: "")
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
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        underDynamicLine.layer.cornerRadius = 9
        underDynamicLine.layer.masksToBounds = true
        iconView.image = UIImage(named: "AppIcon")
        return iconView
    }()
//
    lazy var subDetailTitleLabel: UILabel = {
        var subDetailTitleLabel: UILabel
        subDetailTitleLabel = UILabel()
        subDetailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let str = NSLocalizedString("ML.Setting.cell.Aboutus.Currentversion", value: "Current Version", comment: "") + MLCurrentVersion
        subDetailTitleLabel.text = str
        subDetailTitleLabel.textAlignment = .center
        subDetailTitleLabel.textColor = Colors.detailTextgraycolor
        subDetailTitleLabel.numberOfLines = 4
        subDetailTitleLabel.font = AppStyle.PingFangSC11.font
        return subDetailTitleLabel
    }()

    lazy var settingView: UITableView = {
        let settingView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.backgroundColor = UIColor.white
        settingView.register(MLSettingViewCell.self, forCellReuseIdentifier: MLSettingViewCell.identifier)
        settingView.bounces = false
        settingView.delegate = self
        settingView.dataSource = self
        settingView.separatorStyle = UITableViewCellSeparatorStyle.none
        return settingView
    }()
    let viewModel = MLAboutUsViewModel()
    weak var delegate: MLAboutUsViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addLeftReturnBtn())
    }
    func addLeftReturnBtn() -> UIButton {
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(R.image.ml_wallet_btn_return(), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(dismissViewController), for: UIControlEvents.touchUpInside)
        return leftBtn
    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 61 + kStatusBarHeight),
            underDynamicLine.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 65),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            iconView.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 40),
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            subDetailTitleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
            subDetailTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            settingView.topAnchor.constraint(equalTo: subDetailTitleLabel.bottomAnchor, constant: 24),
            settingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            settingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            settingView.heightAnchor.constraint(equalToConstant: 240),
            ])
    }

    func setup() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(titleLabel)
        self.view.addSubview(underDynamicLine)
        self.view.addSubview(iconView)
        self.view.addSubview(subDetailTitleLabel)
        self.view.addSubview(settingView)
    }

}

extension MLAboutUsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MLSettingViewCell = tableView.dequeueReusableCell(withIdentifier: MLSettingViewCell.identifier, for: indexPath) as! MLSettingViewCell
        cell.settingModel = viewModel.getTitle(i: indexPath.row)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.session
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.row
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didAction(action: viewModel.pushTypes[indexPath.row], in: self)
    }
}

