//
//  LanguageHelper.swift
//  OkToken
//
//  Created by 何志武 on 2019/9/9.
//  Copyright © 2019 oktonken. All rights reserved.
//

import UIKit

class LanguageHelper: NSObject {
    static let shareInstance = LanguageHelper()
    var bundle : Bundle?
    
    
    class func getString(key:String) -> String{
        let bundle = LanguageHelper.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return str!
    }
    
    //初始化app内语言
    func initUserLanguage() {
        var path = ""
        if UserDefaults.standard.value(forKey: "languageStr") == nil {
            //用户没在app里面设置过语言 默认跟随手机系统语言
            if FYTool.getLanguageType() == "en-CN" {
                path = Bundle.main.path(forResource:"en" , ofType: "lproj")!
            }else {
                path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj")!
            }
        }else {
            //用户在app里面设置过语言
            let language = UserDefaults.standard.value(forKey: "languageStr") as! String
            path = Bundle.main.path(forResource:language , ofType: "lproj")!
        }
        bundle = Bundle(path: path)
    }
    
    //重新设置语言
    func setLanguage(langeuage:String) {
        
        let path = Bundle.main.path(forResource:langeuage , ofType: "lproj")
        bundle = Bundle(path: path!)
        
    }
}
