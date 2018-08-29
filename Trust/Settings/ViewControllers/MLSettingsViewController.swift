// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import Localize_Swift

protocol MLSettingsViewControllerDelegate: class {
    func didAction(action: MLPushType, in viewController: MLSettingsViewController)
}

typealias handlerAlertAction = ((UIAlertAction) -> Swift.Void)

class MLSettingsViewController: UIViewController {

    var currencyAlertHandler: handlerAlertAction?
    var languageAlertHandler: handlerAlertAction?

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.text = "settings.navigation.title".localized()
//            R.string.localizable.settingsNavigationTitle().localized()
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

    let viewModel = MLSettingsViewModel()
    weak var delegate: MLSettingsViewControllerDelegate?
    private var config = Config()
    let availableLanguages = Localize.availableLanguages()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 83 + kStatusBarHeight),
            underDynamicLine.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            underDynamicLine.widthAnchor.constraint(equalToConstant: 47),
            underDynamicLine.heightAnchor.constraint(equalToConstant: 4),
            settingView.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: 25),
            settingView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            settingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            settingView.heightAnchor.constraint(equalToConstant: 200),
            ])
    }

    func setup() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(titleLabel)
        self.view.addSubview(underDynamicLine)
        self.view.addSubview(settingView)

        languageAlertHandler = { ( alertAction : UIAlertAction ) in
            //            self.dismiss(animated: false, completion: nil)
            self.setLanguage(kind: self.languageWithString(string: alertAction.title!))

        }
        currencyAlertHandler = { ( alertAction : UIAlertAction ) in
            //            self.dismiss(animated: false, completion: nil)
            self.setCurrency(currency: self.currencyWithString(string: alertAction.title!))
        }
        //                Localize.setCurrentLanguage(language)
        //
        //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeLanguage"), object: self)

    }

    func run(action: MLPushType) {
        delegate?.didAction(action: action, in: self)
    }

    func languageWithString(string: String) -> languageKind {
        switch string {
        case "简体中文":
            return languageKind.chinese
        case "English":
            return languageKind.english
        case "日本語":
            return languageKind.japanese
        case "한국어.":
            return languageKind.korean
        default:
            return languageKind.chinese
        }
    }
    func currencyWithString(string: String) -> Currency {
        switch string {
        case "CNY":
            return Currency.CNY
        case "USD":
            return Currency.USD
        default:
            return Currency.CNY
        }
    }

    func setLanguage(kind: languageKind) {
        print(kind.titleAbbreviation)
        print(kind.title)
//        Localize.setCurrentLanguage(language)
        Localize.setCurrentLanguage(kind.titleAbbreviation)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeLanguage"), object: self)
//        var language = Localize.displayNameForLanguage(kind.titleAbbreviation)
//        if language == "" {
//            language = "default".localized()
//        }
//        Localize.setCurrentLanguage(language)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: self)
//        let localizableVC = MLLocalizableController()
//        let bundle: Bundle = localizableVC.bundle
//        bundle.localizedString(forKey: "", value: "", table: nil)

//        MLLocalizableController().setUserlanguage(language: kind.titleAbbreviation)
        self.run(action: .MutiLanguage)
    }
    func setLanguage(language: String) {
        Localize.setCurrentLanguage(language)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: self)
        self.run(action: .MutiLanguage)
    }
    func setCurrency(currency: Currency) {
        self.config.currency = currency
        self.run(action: .Unit)
    }

    lazy var languageAlertViewController: UIAlertController = {
        var title = NSLocalizedString("ML.Setting.cell.Multilingual", value: "Multilingual", comment: "")
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = self.view
        for language in availableLanguages {
            print(language)
            var displayName = Localize.displayNameForLanguage(language)
            if displayName == "" {
                displayName = "default".localized()
            }
            let alertAction = UIAlertAction(title: displayName, style: UIAlertActionStyle.default, handler: { ( alertAction : UIAlertAction ) in
                self.setLanguage(language: language)
            })
            alertController.addAction(alertAction)
        }
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: UIAlertActionStyle.cancel, handler: nil))
        return alertController
    }()

    lazy var currencyAlertViewController: UIAlertController = {
        var title = NSLocalizedString("settings.network.test.warnning.title", value: "Monetary Unit", comment: "")
//        var title = NSLocalizedString("ML.Setting.cell.MonetaryUnit", value: "Monetary Unit", comment: "")
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: "CNY", style: UIAlertActionStyle.default, handler: currencyAlertHandler))
        alertController.addAction(UIAlertAction(title: "USD", style: UIAlertActionStyle.destructive, handler: currencyAlertHandler))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: UIAlertActionStyle.cancel, handler: nil))
        return alertController
    }()
}

extension MLSettingsViewController: UITableViewDelegate,UITableViewDataSource {
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
        let pushType: MLPushType = viewModel.pushTypes[indexPath.row]
        switch pushType {
        case .MutiLanguage: //多语言
            self.present(languageAlertViewController, animated: false, completion: nil)
            return
        case .Unit: //货币单位
            self.present(currencyAlertViewController, animated: false, completion: nil)
            return
        default:
            break
        }

        delegate?.didAction(action: viewModel.pushTypes[indexPath.row], in: self)
    }
}
