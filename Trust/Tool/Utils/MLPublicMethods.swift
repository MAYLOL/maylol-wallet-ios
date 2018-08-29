// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import CoreGraphics
import UIKit

///// 计算文字高度
//public func MLTextHeight(text:NSString,width:CGFloat,fontSize:CGFloat) -> CGFloat {
//    let size = CGSize.init(width: width, height: 10000)
//
//    let style = NSMutableParagraphStyle()
//    style.lineSpacing = 15
//    let rect = text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSParagraphStyleAttributeName:style], context: nil)
//
//    return rect.size.height
//}

func sizeWithText(text: NSString, font: UIFont, size: CGSize) -> CGRect {
    let attributes = [NSAttributedStringKey.font: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect: CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
    return rect
}
//适配 350 375 414       568 667 736
func kAutoLayoutWidth(_ width: CGFloat) -> CGFloat {
    return width*kScreenW / 375
}

func kAutoLayoutHeigth(_ height: CGFloat) -> CGFloat {
    return height*kScreenH! / 667
}

//机型判断
//let kUI_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone)
//let kUI_IPHONE5 = (kUI_IPHONE && ksccreen == 568.0)
//let kUI_IPHONE6 = (kUI_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
//let kUI_IPHONEPLUS = (kUI_IPHONE && kSCREEN_MAX_LENGTH == 736.0)
//let kUI_IPHONEX = (kUI_IPHONE && kSCREEN_MAX_LENGTH > 780.0)

////获取状态栏、标题栏、导航栏高度
//let kUIStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//let kUINavigationBarHeight: CGFloat =  kUI_IPHONEX ? 88 : 44
//let KUITabBarHeight: CGFloat = kUI_IPHONEX ? 83 : 49
////navigationBarHeight默认高度44 （iPhoneX 88）
////tabBarHeight默认高度49     （iPhoneX 83）



