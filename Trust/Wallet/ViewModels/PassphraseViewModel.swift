// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

struct PassphraseViewModel {

    var title: String {
        return "ML.BackupPhrase".localized()
    }
    var subTitle: String {
        return "ML.Write.Phrase".localized()
    }
    var subTitleTips: String {
        return "ML.Write.PhraseTips".localized()
    }

    var backgroundColor: UIColor {
        return .white
    }

    var phraseFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
