// Copyright DApps Platform Inc. All rights reserved.

import UIKit

enum AppStyle {
    case heading
    case headingSemiBold
    case paragraph
    case paragraphLight
    case paragraphSmall
    case largeAmount
    case error
    case formHeader
    case collactablesHeader
    case PingFangSC9
    case PingFangSC10
    case PingFangSC11
    case PingFangSC12
    case PingFangSC13
    case PingFangSC14
    case PingFangSC15
    case PingFangSC18
    case PingFangSC24
    case PingFangSC30


    var font: UIFont {
        switch self {
        case .heading:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .headingSemiBold:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .paragraph:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .paragraphSmall:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .paragraphLight:
            return UIFont.systemFont(ofSize: 15, weight: .light)
        case .largeAmount:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .error:
            return UIFont.systemFont(ofSize: 13, weight: .light)
        case .formHeader:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .collactablesHeader:
            return UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.regular)
        case .PingFangSC9:
            return UIFont(name: "PingFang SC", size: 9)!
        case .PingFangSC10:
            return UIFont(name: "PingFang SC", size: 10)!
        case .PingFangSC11:
            return UIFont(name: "PingFang SC", size: 11)!
        case .PingFangSC12:
            return UIFont(name: "PingFang SC", size: 12)!
        case .PingFangSC13:
            return UIFont(name: "PingFang SC", size: 13)!
        case .PingFangSC14:
            return UIFont(name: "PingFang SC", size: 14)!
        case .PingFangSC15:
            return UIFont(name: "PingFang SC", size: 15)!
        case .PingFangSC18:
            return UIFont(name: "PingFang SC", size: 18)!
        case .PingFangSC24:
            return UIFont(name: "PingFang SC", size: 24)!
        case .PingFangSC30:
            return UIFont(name: "PingFang SC", size: 30)!
        }
    }

    var textColor: UIColor {
        switch self {
        case .heading, .headingSemiBold:
            return Colors.black
        case .paragraph, .paragraphLight, .paragraphSmall:
            return Colors.charcoal
        case .largeAmount:
            return UIColor.black // Usually colors based on the amount
        case .error:
            return Colors.errorRed
        case .formHeader:
            return Colors.doveGray
        case .collactablesHeader:
            return Colors.lightDark
        case .PingFangSC9:
            return Colors.detailTextgraycolor
        case .PingFangSC10:
            return Colors.ccccccolor
        case .PingFangSC11:
            return Colors.detailTextgraycolor
        case .PingFangSC12:
            return Colors.detailTextgraycolor
        case .PingFangSC13:
            return Colors.er262626color
        case .PingFangSC14:
            return Colors.detailTextgraycolor
        case .PingFangSC15:
            return Colors.detailTextgraycolor
        case .PingFangSC18:
            return Colors.er262626color
        case .PingFangSC24:
            return Colors.titleBlackcolor
        case .PingFangSC30:
            return Colors.titleBlackcolor

        }
    }
}
