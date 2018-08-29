// Copyright DApps Platform Inc. All rights reserved.

import Foundation

enum languageKind {
    case chinese
    case english
    case japanese
    case korean
    var title: String {
        switch self {
        case .chinese:
            return "简体中文"
        case .english:
            return "English"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어."
        }
    }
    var titleAbbreviation: String {
        switch self {
        case .chinese:
            return "zh-Hans"
        case .english:
            return "en"
        case .japanese:
            return "ja"
        case .korean:
            return "ko"
        }
    }

//    ["de", "ar", "zh-Hans", "ja", "en", "es", "it", "zh-Hant", "vi", "ru", "fr"]

//    var currency: Currency {
//        switch self {
//        case .chinese:
//            return .CNY
//        case .english:
//            return .
//        case .japanese:
//            return "日本語"
//        case .korean:
//            return "한국어."
//        }
//    }

//    func languageWithString(string: String) -> languageKind{
//        switch string {
//        case "简体中文":
//            return languageKind.chinese
//        case "English":
//            return languageKind.english
//        case "日本語":
//            return languageKind.japanese
//        case "한국어.":
//            return languageKind.korean
//        default:
//            return languageKind.chinese
//        }
//    }
}

struct MLSettingsViewModel {
    let session: Int = 1
    var row: Int {
        get {
            return settingText.count
        }
    }
    let settingText: [String] = [
//        "transaction.time.label.title".localized(),
        "setting.multilingual".localized(),
        "ML.Setting.cell.MonetaryUnit".localized(),
        "ML.Setting.cell.Aboutus".localized()
//        NSLocalizedString("ML.Setting.cell.Multilingual", value: "Multilingual", comment: ""),
//        NSLocalizedString("ML.Setting.cell.MonetaryUnit", value: "Monetary unit", comment: ""),
//        NSLocalizedString("ML.Setting.cell.Aboutus", value: "About us", comment: ""),
        ]
    
    let pushTypes: [MLPushType] = [
        .MutiLanguage, //多语言
        .Unit, //货币单位
        .AboutUs, //关于我们
    ]
    func getTitle(i: Int) -> String {
        let title = settingText[i]
        return title
    }
}
