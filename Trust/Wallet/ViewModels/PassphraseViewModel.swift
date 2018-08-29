// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

struct PassphraseViewModel {

    var title: String {
        return R.string.localizable.backupPhrase()
    }
    var subTitle: String {
//        return R.string.localizable.mlWritePhrase()
        return NSLocalizedString("ML.Write.Phrase", value: "抄下你的钱包助记词！", comment: "")
    }
    var subTitleTips: String {
//        return R.string.localizable.mlWritePhraseTips()
        return NSLocalizedString("ML.Write.PhraseTips", value: "助记词用于恢复钱包或重置钱包密码，将他准确的抄写在纸上并存放在只有你知道的安全的地方", comment: "")
    }

    var backgroundColor: UIColor {
        return .white
    }

    var phraseFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
