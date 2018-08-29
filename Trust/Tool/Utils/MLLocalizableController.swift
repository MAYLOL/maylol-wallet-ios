// Copyright DApps Platform Inc. All rights reserved.

import Foundation

class MLLocalizableController: Bundle {

    var bundleS: Bundle? = nil
//    var bundle: Bundle {
//        get {
//            return bundleS!
//        }
//    }

    func bundle() -> MLLocalizableController {

        return bundleS as! MLLocalizableController
    }

    //获取文件路径
    func initUserLanguage(){
        let def = UserDefaults.standard
        var string: String = def.value(forKey: "userLanguage") as! String
        if string.length == 0{
            //获取系统当前语言版本
            let languages: NSArray = def.object(forKey: "AppleLanguages") as! NSArray
            let current: String = languages.object(at: 0) as! String
            string = current
            def.setValue(current, forKey: "userLanguage")
            def.synchronize()
        }
        let path: String = Bundle.main.path(forResource: string, ofType: "lproj")!
        bundleS = Bundle(path: path)
    }

    func userLanguage() -> String {
        let def = UserDefaults.standard
        var language: String = def.value(forKey: "userLanguage") as! String
        return language
    }

    func setUserlanguage(language: String) {
        let def = UserDefaults.standard
        let path: String = Bundle.main.path(forResource: language, ofType: "lproj")!
        bundleS = Bundle(path: path)
        def.setValue(language, forKey: "userLanguage")
        def.synchronize()
    }

//    5. 自定义一个宏方便处理：
//
//    // ----- 多语言设置
//    #define CHINESE @zh-Hans
//    #define ENGLISH @en
//    #define GDLocalizedString(key) [[GDLocalizableController bundle] localizedStringForKey:(key) value:@ table:nil]
//
//    6.使用：
//    [GDLocalizableController setUserlanguage:CHINESE];
//    NSLog(GDLocalizedString(@SUBMIT_BTN_TITLE));
//    [GDLocalizableController setUserlanguage:ENGLISH];
//    NSLog(GDLocalizedString(@SUBMIT_BTN_TITLE));
}
