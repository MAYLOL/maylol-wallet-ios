// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

enum MLErrorType: LocalizedError {
    case WalletNameEmptyError//钱包名字相关！
    case PasswordformatError//请输入6-16数字和字母组合组成的密码！
    case PasswordNotEqual//密码前后不相等！
    case PasswordInvalid//无效的！
    case PasswordError//密码不匹配！
    case PasswordEmpty//密码不能为空！
    case ReadProtocolNotRead//阅读协议错误相关！
    case PhraseInvalidError//助记词错误！
    case PrivateInvalidError //私钥错误！
    case Private64CharactersError //Private Key has to be 64 characters long
    case CustomError(errorString:String)//自定义Error！
    case invalidAddress//以太坊地址无效
    case invalidAmount//数量输入错误
    case gasTooLowError//gas数量过低
    case gasTooHeightError//gas数量过高
    case gasPriseTooLowError//gasPrise数量过低
    case gasPriseTooHeightError//gasPrise数量过高
    case None

    var errorDescription: String? {
            switch self {
            case .invalidAddress:
                return NSLocalizedString("send.error.invalidAddress", value: "Invalid Address", comment: "")
            case .invalidAmount:
                return NSLocalizedString("send.error.invalidAmount", value: "Invalid Amount", comment: "")
            case .WalletNameEmptyError:
                   return "钱包名字不能为空！"
            case .PasswordformatError:
                return "请输入6-16数字和字母组合组成的密码！"
            case .PasswordNotEqual:
                return "密码前后不相等！"
            case .PasswordInvalid:
                return "密码无效！"
            case .PasswordError:
                return "密码不匹配！"
            case .PasswordEmpty:
                return "密码不能为空！"
            case .ReadProtocolNotRead:
                return "请阅读协议并同意！"
            case .PhraseInvalidError:
                return "Field required!"
            case .PrivateInvalidError:
                return "私钥无效！"
            case .Private64CharactersError:
                return "Private Key has to be 64 characters long"
            case .CustomError(let errorString):
                return errorString
            case .gasTooLowError://gas数量过低
                return "Gas值应该大于 21000"
            case .gasTooHeightError://gas数量过高
                return "Gas值应该小于600000"
            case .gasPriseTooLowError://gasPrise数量过低
                return "Gas prise太低，建议应该大于1 gwei"
            case .gasPriseTooHeightError://gasPrise数量过高
                return "Gas prise太高，值应该小于 100 gwei"
            case .None:
                return ""
        }
    }
//    var title: String {
//        switch self {
//        case .WalletNameEmptyError:
//            return "钱包名字不能为空！"
//        case .PasswordformatError:
//            return "请输入6-16数字和字母组合组成的密码！"
//        case .PasswordNotEqual:
//            return "密码前后不相等！"
//        case .PasswordInvalid:
//            return "密码无效！"
//        case .ReadProtocolNotRead:
//            return "请阅读协议并同意！"
//        case .PhraseInvalidError:
//            return "Field required!"
//        case .PrivateInvalidError:
//            return "私钥无效！"
//        case .Private64CharactersError:
//            return "Private Key has to be 64 characters long"
//        case .CustomError(let errorString):
//            return errorString
//        case .None:
//            return ""
//        }
//    }
//
//    var error: NSError {
//        switch self {
//        case .WalletNameEmptyError:
//
//        case .PasswordformatError:
//            return NSError(domain: "请输入6-16数字和字母组合组成的密码！", code: 200002, userInfo: ["MLErrorType" : MLErrorType.PasswordformatError])
//        case .PasswordNotEqual:
//            return NSError(domain: "密码前后不相等！", code: 200003, userInfo: ["MLErrorType" : MLErrorType.PasswordNotEqual])
//        case .PasswordInvalid:
//            return NSError(domain: "密码无效！", code: 200004, userInfo: ["MLErrorType" : MLErrorType.PasswordInvalid])
//        case .ReadProtocolNotRead:
//            return NSError(domain: "请阅读协议并同意！", code: 200005, userInfo: ["MLErrorType" : MLErrorType.ReadProtocolNotRead])
//        case .PhraseInvalidError:
//            return NSError(domain: "Field required!", code: 200006, userInfo: ["MLErrorType" : MLErrorType.PhraseInvalidError])
//        case .PrivateInvalidError:
//            return NSError(domain: "私钥无效！", code: 200007, userInfo: ["MLErrorType" : MLErrorType.PrivateInvalidError])
//        case .Private64CharactersError:
//            return NSError(domain: "Private Key has to be 64 characters long", code: 200008, userInfo: ["MLErrorType" : MLErrorType.Private64CharactersError])
//        case .CustomError(let errorString):
//            return NSError(domain: errorString, code: 200009, userInfo: ["MLErrorType" : MLErrorType.CustomError])
//        case .None:
//            return NSError()
//        }
//    }

//    func tips(view:UIView){
//        var state: String
//        switch self {
//        case .WalletNameEmptyError:
//            state = "钱包名字不能为空！"
//        case .PasswordformatError:
//            state = "请输入6-16数字和字母组合组成的密码！"
//        case .PasswordNotEqual:
//            state = "密码前后不相等！"
//        case .PasswordInvalid:
//            state = "密码无效！"
//        case .ReadProtocolNotRead:
//            state = "请阅读协议并同意！"
//        case .PhraseInvalidError:
//            state = "Field required!"
//        case .PrivateInvalidError:
//            state = "私钥无效！"
//        case .Private64CharactersError:
//            state = "Private Key has to be 64 characters long"
//        case .CustomError(let errorString):
//            state = errorString
//        case .None:
//            state = ""
//            return
//        }
//        MLProgressHud.show(view: view,status:.Error, state:self.title)
//    }
}
