// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

enum MLPushType {
    case QRCode
    case CreateWallte
    case ImportWallte
    case Setting
    case MutiLanguage //多语言
    case Unit //货币单位
    case Web3 //设置
    case AboutUs //关于我们
    case UseProtocol //使用协议
    case PrivacyClause //隐私条款
    case ProductGuide //产品向导
    case DetectionUpdate //检测更新
}

struct MLWalletSettingModel {
    var settingText: String
    var settingIcon: UIImage
    init(setText: String,
         setIcon: UIImage) {
        settingText = setText
        settingIcon = setIcon
    }
}

struct MLWalletSettingViewModel {



    let session: Int = 1
    var row: Int {
        get {
            return settingIcon.count
        }
    }
    let settingText: [String] = [
        "browser.qrCode.button.title".localized(),
        "welcome.createWallet.button.title".localized(),
        "welcome.importWallet.button.title".localized()
//        R.string.localizable.welcomeCreateWalletButtonTitle().localized(),
//        R.string.localizable.welcomeImportWalletButtonTitle().localized(),
//        R.string.localizable.browserQrCodeButtonTitle().localized(),
//        R.string.localizable.welcomeCreateWalletButtonTitle().localized(),
//        R.string.localizable.welcomeImportWalletButtonTitle().localized(),
        ]

    let settingIcon: [UIImage] = [
        R.image.ml_wallet_menu_icon_scan()!,
        R.image.ml_wallet_menu_icon_wallet()!,
        R.image.ml_wallet_menu_icon_import()!,
        ]

    let pushTypes: [MLPushType] = [
        .QRCode,
        .CreateWallte,
        .ImportWallte,
    ]
    func getModel(i: Int) -> MLWalletSettingModel {
        let settingModel:MLWalletSettingModel = MLWalletSettingModel(setText: settingText[i], setIcon: settingIcon[i])
        return settingModel
    }
}


