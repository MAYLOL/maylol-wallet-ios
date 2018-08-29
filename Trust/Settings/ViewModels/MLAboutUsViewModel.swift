// Copyright DApps Platform Inc. All rights reserved.

import Foundation

struct MLAboutUsViewModel {
    let session: Int = 1
    var row: Int {
        get {
            return settingText.count
        }
    }
    let settingText: [String] = [
        "ML.Setting.cell.Aboutus.UseProtocol".localized(),
"ML.Setting.cell.Aboutus.PrivacyClause".localized(),
"ML.Setting.cell.Aboutus.ProductGuide".localized(),
"ML.Setting.cell.Aboutus.DetectionUpdate".localized()
//        NSLocalizedString("ML.Setting.cell.Aboutus.UseProtocol", value: "Use Protocol", comment: ""),
//        NSLocalizedString("ML.Setting.cell.Aboutus.PrivacyClause", value: "Privacy Clause", comment: ""),
//        NSLocalizedString("ML.Setting.cell.Aboutus.ProductGuide", value: "Product Guide", comment: ""),
//                NSLocalizedString("ML.Setting.cell.Aboutus.DetectionUpdate", value: "Detection Update", comment: ""),
        ]
    let pushTypes: [MLPushType] = [
        .UseProtocol, //使用协议
        .PrivacyClause, //隐私条款
        .ProductGuide, //产品向导
        .DetectionUpdate,//检测更新
    ]
    func getTitle(i: Int) -> String {
        let title = settingText[i]
        return title
    }
}
