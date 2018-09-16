// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class MLCheckVersionManager: NSObject {
    /// app版本更新检测
    ///
    /// - Parameter appId: apple ID - 开发者帐号对应app处获取
    init(appId:String) {
        super.init()

        //获取appstore上的最新版本号
        let appUrl = URL.init(string: "http://itunes.apple.com/lookup?id=" + appId)
        let appMsg = try? String.init(contentsOf: appUrl!, encoding: .utf8)
        let appMsgDict: NSDictionary = getDictFromString(jString: appMsg!)
        let appResultsArray: NSArray = ((appMsgDict["results"] as? NSArray) ?? nil)!
        guard appResultsArray.lastObject != nil else {
            MLProgressHud.show(message: "ML.App.Update.IsNew".localized())
            return
        }
        let appResultsDict: NSDictionary = appResultsArray.lastObject as! NSDictionary
        let appStoreVersion: String = appResultsDict["version"] as! String
        let appStoreVersion_Float: Float = Float(appStoreVersion)!

        //获取当前手机安装使用的版本号
        let localVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let localVersion_Float: Float = Float(localVersion)!

        //用户是否设置不再提示
        let userDefaults = UserDefaults.standard
        let res = userDefaults.bool(forKey: "NO_ALERt_AGAIN")
        //appstore上的版本号大于本地版本号 - 说明有更新
        if appStoreVersion_Float > localVersion_Float && !res {
            let alertC = UIAlertController.init(title: "ML.App.Update.Tip".localized(), message: "ML.App.Update.SubTitle".localized(), preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "ML.App.Update.Go".localized(), style: .default, handler: { (handler) in
                self.updateApp(appId: appId)
            })
            let noAction = UIAlertAction.init(title: "ML.App.Update.Next".localized(), style: .cancel, handler: nil)
//            let cancelAction = UIAlertAction.init(title: "ML.App.Update.NoTips".localized(), style: .default, handler: { (handler) in
//                self.noAlertAgain()
//            })
            alertC.addAction(yesAction)
            alertC.addAction(noAction)
//            alertC.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
        } else {
            MLProgressHud.show(message: "ML.App.Update.IsNew".localized())
        }

    }

    //去更新
    func updateApp(appId: String) {
        let updateUrl: URL = URL.init(string: "http://itunes.apple.com/app/id" + appId)!
        UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
    }

    //不再提示
    func noAlertAgain() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "NO_ALERt_AGAIN")
        userDefaults.synchronize()
    }

    //JSONString转字典
    func getDictFromString(jString: String) -> NSDictionary {
        let jsonData: Data = jString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }

        return NSDictionary()
    }
}
