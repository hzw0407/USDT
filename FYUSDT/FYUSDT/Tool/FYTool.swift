//
//  FYTool.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit
import LocalAuthentication

class FYTool: NSObject {
    /// 获取字符串高度
    ///   - textStr: 需要计算的字符串
    ///   - font: 字体大小
    ///   - width: 宽度
    /// - Returns: 返回计算的高度
    static func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 100000)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let stringSize = textStr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        return stringSize.height
    }
    
    /// 获取字符串宽度
    ///   - textStr: 需要计算的字符串
    ///   - font: 字体大小
    ///   - height: 高度
    /// - Returns: 返回计算的宽度
    static func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let size = CGSize(width: 1000, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let stringSize = textStr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        return stringSize.width
    }
        
    //时间戳转时间
    static func timeStampChange(timeStamp:TimeInterval,formatStr:String) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatStr
        let time = dateformatter.string(from: date as Date)
        return time
    }
    
    //秒数转换成时分秒（00:00:00）格式
    static func transToHourMinSec(time: Int) -> String {
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = time / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = time % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = time % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
        
    //去除小数点后面以0结尾的0
    static func removeZero(handleStr:String) -> String{
        
        var outStr = handleStr
        var i = 1
        
        if handleStr.contains("."){
            while i < handleStr.count{
                if outStr.hasSuffix("0"){
                    outStr.remove(at: outStr.index(before: outStr.endIndex))
                    i = i + 1
                }else{
                    break
                }
            }
            if outStr.hasSuffix("."){
                outStr.remove(at: outStr.index(before: outStr.endIndex))
            }
            return outStr
        }
        else{
            return handleStr
        }
    }
    
    static func truncation(index:Double,data:Double) -> Double {
        let tempInt = Int(data * index)
        let tempDouble = Double(tempInt) / index
        return tempDouble
    }
        
    //判断输入的邮箱是否正确
    static func isvaliteemail(email:String) -> Bool {
        let dssf = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        guard let regex = try? NSRegularExpression(pattern: dssf, options: .caseInsensitive) else {
            return false
        }
        if let results =  try?regex.matches(in: email, options: [], range: NSRange(location: 0, length: email.count)) {
            return results.count > 0
        }else {
            return false
        }
    }
        
    //只能输入数字和小数点
        static func checkInput(inputStr:String) -> Bool {
            let expression = "^[0-9]*((\\.)[0-9]{0,2})?$"
    //        let expression = "^[0-9]*$"
            guard let regex = try? NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace) else {
                return false
            }
            if let numberOfMatches = try?regex.matches(in: inputStr, options:[], range: NSRange(location: 0, length: inputStr.count)) {
                return numberOfMatches.count > 0
            }else {
                return false
            }
        }
        
    //获取手机系统语言
    static func getLanguageType() -> String {
        if UserDefaults.standard.value(forKey: "languageStr") == nil {
            //没有设置过语言 跟随系统语言
            let def = UserDefaults.standard
            let allLanguages: [String] = def.object(forKey: "AppleLanguages") as! [String]
            let chooseLanguage = allLanguages.first
            return chooseLanguage ?? "en-CN"
        }else {
            //设置过语言 使用上次设置的
            if UserDefaults.standard.value(forKey: "languageStr") as! String == "en" {
                return "en-CN"
            }else {
                return "zh-Hans"
            }
        }
        
//        let def = UserDefaults.standard
//        let allLanguages: [String] = def.object(forKey: "AppleLanguages") as! [String]
//        let chooseLanguage = allLanguages.first
//        return chooseLanguage ?? "en-CN"
    }
        
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }

    //十六进制颜色转UIColor
    public static func hexStringToUIColor(hexString: String) ->UIColor  {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
