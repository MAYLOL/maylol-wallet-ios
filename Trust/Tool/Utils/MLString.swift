// Copyright DApps Platform Inc. All rights reserved.

import Foundation

extension String {
    func isPrivateValid(value: String) -> Bool {
        if value.length != 64 || value.kStringIsEmpty(value) {
            return false
        }
        return true
    }
    func isPhraseValid(value: String) -> Bool {
        if (value.kStringIsEmpty(value)){
            return false
        }
        return true
    }
}
