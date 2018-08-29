// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

let ShareApplication = UIApplication.shared

let ShareAppDelegate = UIApplication.shared.delegate as! AppDelegate

/// 屏幕宽度
public var kScreenW: CGFloat = kWindow!.bounds.width

/// 屏幕高度
public let kScreenH = kWindow?.bounds.height

/// 屏幕尺寸
public let kScreenSize = kWindow?.bounds.size

/// 屏幕比例
public let kScreenScale = UIScreen.main.scale

/// 统一转场动画时长
public let kViewTransDuration = 0.25

public let kWindow = ShareAppDelegate.window

//let ShareAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

/**
 设置状态栏样式为白色
 */
public func MLStatusBarStyleLight() {
    ShareApplication.statusBarStyle = UIStatusBarStyle.lightContent
}

/**
 设置状态栏样式为黑色
 */
public func MLStatusBarSytleDefault() {
    ShareApplication.statusBarStyle = UIStatusBarStyle.default
}

public let kCurrentLanguage = "kCurrentLanguage"
/// 当前系统版本
public let MLCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
// MARK: - 判断 机型
public let isiPhone5 = UIDevice.isiPhone5()
public let isiPhone6 = UIDevice.isiPhone6()
public let isiPhone6BigModel = UIDevice.isiPhone6BigMode()
public let isiPhone6Plus = UIDevice.isiPhone6Plus()
public let isiPhone6PlusBigMode = UIDevice.isiPhone6PlusBigMode()
public let isiPhoneX = UIDevice.isiPhoneX()
public let isIpad = UIDevice.isAiPad()

// MARK: - 系统类型
public let kisiOS11 = UIDevice.isiOS11()
public let kisiOS10 = UIDevice.isiOS10()
public let kisiOS9 = UIDevice.isiOS9()
public let kisiOS8 = UIDevice.isiOS8()

//获取状态栏、标题栏、导航栏高度
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
let kNavigationBarHeight: CGFloat =  isiPhoneX ? 88 : 44
let KTabBarHeight: CGFloat = isiPhoneX ? 83 : 49
//navigationBarHeight默认高度44 （iPhoneX 88）
//tabBarHeight默认高度49     （iPhoneX 83）
let KBottomSafeHeight: CGFloat = isiPhoneX ? 34 : 0

extension UIDevice {

    func Version()->String{

        let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return appVersion
    }


    @objc public class func isiPhoneX() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 1125, height: 2436)))! {
            return true
        }
        return false
    }

    public class func isiPhone6PlusBigMode() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 1125, height: 2001)))! {
            return true
        }
        return false
    }

    public class func isiPhone6Plus() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width:1242, height: 2208)))! {
            return true
        }
        return false
    }

    public class func isiPhone6BigMode() -> Bool{
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 320, height: 568)))! {
            return true
        }
        return false
    }

    public class func isiPhone6() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width:750, height: 1334)))! {
            return true
        }
        return false
    }

    public class func isiPhone5() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 640, height: 1136)))! {
            return true
        }
        return false
    }

    public class func isiOS11() -> Bool {
        if #available(iOS 11.0, *) {
            return true
        } else {
            return false
        }
    }

    public class func isiOS10() -> Bool {
        if #available(iOS 10.0, *) {
            return true
        } else {
            return false
        }
    }

    public class func isiOS9() -> Bool {
        if #available(iOS 9.0, *) {
            return true
        } else {
            return false
        }
    }

    public class func isiOS8() -> Bool {
        if #available(iOS 8.0, *) {
            return true
        } else {
            return false
        }
    }

    public class func isAiPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        }
        return false
    }
}

