// Copyright DApps Platform Inc. All rights reserved.

import Foundation

enum SendInputErrors: LocalizedError {
    case emptyClipBoard
    case wrongInput

    var errorDescription: String? {
        switch self {
        case .emptyClipBoard:
            return "send.error.emptyClipBoard".localized()
        case .wrongInput:
            return "send.error.wrongInput".localized()
        }
    }
}
