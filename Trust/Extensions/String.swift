// Copyright DApps Platform Inc. All rights reserved.

import Foundation

extension String {
    var hex: String {
        let data = self.data(using: .utf8)!
        return data.map { String(format: "%02x", $0) }.joined()
    }

    var hexEncoded: String {
        let data = self.data(using: .utf8)!
        return data.hexEncoded
    }

    var isHexEncoded: Bool {
        guard starts(with: "0x") else {
            return false
        }
        let regex = try! NSRegularExpression(pattern: "^0x[0-9A-Fa-f]*$")
        if regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).isEmpty {
            return false
        }
        return true
    }

    var doubleValue: Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = "."
        if let result = formatter.number(from: self) {
            return result.doubleValue
        } else {
            formatter.decimalSeparator = ","
            if let result = formatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }

    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var asDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        }
        return [:]
    }

    var drop0x: String {
        if self.count > 2 && self.substring(with: 0..<2) == "0x" {
            return String(self.dropFirst(2))
        }
        return self
    }

    var add0x: String {
        return "0x" + self
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension String {

    //获取字符串的长度
    var length : Int {
        return self.characters.count
    }
    //获得字符串的长度：
    var convertToInt : Int {
        var stringLength = 0
        let string = NSString(string: self)

        var p = string.cString(using: String.Encoding.unicode.rawValue)

        for _ in 0..<(string.lengthOfBytes(using: String.Encoding.unicode.rawValue)) {
            if p != nil {
                p = p?.successor()
                stringLength += 1
            } else {
                p = p?.successor()
            }
        }
        return (stringLength + 1) / 2
    }

    /**
     字符串是否为空
     @param str NSString 类型 和 子类
     @return  BOOL类型 true or false
     */
    func kStringIsEmpty(_ str: String!) -> Bool {
        if str.isEmpty {
            return true
        }
        if str == nil {
            return true
        }
        if str.count < 1 {
            return true
        }
        if str == "(null)" {
            return true
        }
        if str == "null" {
            return true
        }
        return false
    }

    // 字符串判空 如果为空返回@“”
    func kStringNullToempty(_ str: String) -> String {
        let resutl = kStringIsEmpty(str) ? "" : str
        return resutl
    }
    func kStringNullToReplaceStr(_ str: String,_ replaceStr: String) -> String {
        let resutl = kStringIsEmpty(str) ? replaceStr : str
        return resutl
    }

    func isPassword(pasword : String) -> Bool {

        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"

        let regextestpwd = NSPredicate(format: "SELF MATCHES %@",pwd)

        if (regextestpwd.evaluate(with: pasword) == true) {

            return true

        }else{

            return false

        }

    }
}
