// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import KeychainSwift

class MLKeychain {
    //简便写法
    class share {
        static let `default` = MLKeychain()
    }
    func getKeychainQuery(service: String) -> NSMutableDictionary {
        return NSMutableDictionary(dictionary:
            [kSecClass: kSecClassGenericPassword,
             kSecAttrService: service,
             kSecAttrAccount: service,
             kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock])
    }
    func saveKeychain(service: String, data: AnyObject) {
        let keychainQuery = self.getKeychainQuery(service: service)
        SecItemDelete(keychainQuery)
        keychainQuery.addEntries(from: [kSecValueData: NSKeyedArchiver.archivedData(withRootObject: data)])
        SecItemAdd(keychainQuery, nil)
    }
    func loadKeychain(service: String) -> AnyObject! {
        let keychainQuery = self.getKeychainQuery(service: service)
        keychainQuery.addEntries(from: [kSecReturnData: kCFBooleanTrue])
        keychainQuery.addEntries(from: [kSecMatchLimit: kSecMatchLimitOne])
        var keyData : AnyObject? = nil
        if SecItemCopyMatching(keychainQuery, &keyData) == noErr {
            let ret = NSKeyedUnarchiver.unarchiveObject(with: (keyData as! NSData) as Data)
            return ret as AnyObject
        } else {
            return nil
        }
    }
    func deleteKeychain(service: String) {
        let keychainQuery = self.getKeychainQuery(service: service)
        SecItemDelete(keychainQuery)
    }

    func verify(passworld inputpwd: String,service: String) -> Bool {
        let pwd = self.loadKeychain(service: service) as! String
        if pwd == inputpwd {
            return true
        }
        return false
    }
}


