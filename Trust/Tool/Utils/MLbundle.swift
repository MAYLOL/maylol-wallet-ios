//// Copyright DApps Platform Inc. All rights reserved.
//
//import Foundation
//
///**
// *  当调用onLanguage后替换掉mainBundle为当前语言的bundle
// */
//
//class BundleEx: Bundle {
//
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        if let bundle = Bundle.getLanguageBundel() {
//            return bundle.localizedString(forKey: key, value: value, table: tableName)
//        }else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
//    }
//}
//
//
//extension Bundle {
//
//    private static var onLanguageDispatchOnce: ()->Void = {
//        //替换Bundle.main为自定义的BundleEx
//        object_setClass(Bundle.main, BundleEx.self)
//    }
//
//    func onLanguage(){
//        Bundle.onLanguageDispatchOnce()
//UserDefaults.standard
//    }
//
//    class func getLanguageBundel() -> Bundle? {
//        let languageBundlePath = Bundle.main.path(forResource: UserDefaults.standard[kCurrentLanguage] as? String, ofType: "lproj")
//        //        print("path = \(languageBundlePath)")
//        guard languageBundlePath != nil else {
//            return nil
//        }
//        let languageBundle = Bundle.init(path: languageBundlePath!)
//        guard languageBundle != nil else {
//            return nil
//        }
//        return languageBundle!
//
//    }
//}
