//
//  FYRequestManager.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

enum requestType {
    case get
    case post
}

class FYRequestManager: NSObject {

    static let shared = FYRequestManager()
    
    //0测试环境 1正式环境
    let InterfaceBaseDebug = 0
    var baseUrl = ""
    //参数字典
    var parametersDic:[String : AnyObject] = [:]
    
    private func judgeNetwork() {
        if InterfaceBaseDebug == 1 {
            baseUrl = "http://192.168.0.112:8088"
        }else {
            baseUrl = "http://www.usdtvip.cn:8088"
        }
    }
    
    //添加参数
    func addparameter(key:String,value:AnyObject) {
        self.parametersDic[key] = value as AnyObject
    }
    
    //清空参数
    func clearparameter() {
        self.parametersDic.removeAll()
    }
    
    func request(type:requestType,
                 url:String,
                 successCompletion:@escaping(_ dict:[String : AnyObject],_ message:String)->(),
                 failureCompletion:@escaping(_ message:String)->()) -> Void {
        self.judgeNetwork()
        let tempUrl = baseUrl + url
        if type == requestType.get {
            //get请求
            Alamofire.request(tempUrl, method: .get, parameters: self.parametersDic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        let tempDic = (jsonString as! [String : AnyObject])
                        if !tempDic.keys.contains("error") {
                            let enMessage = (jsonString as! [String : AnyObject])["enMessage"] as! NSString
                            let message = (jsonString as! [String : AnyObject])["message"] as! NSString
                            if UserDefaults.standard.value(forKey: "languageStr") == nil {
                                if FYTool.getLanguageType() == "en-CN" {
                                    successCompletion(jsonString as! [String : AnyObject],enMessage as String)
                                }else {
                                    successCompletion(jsonString as! [String : AnyObject],message as String)
                                }
                            }else {
                                if UserDefaults.standard.value(forKey: "languageStr") as! String == "en" {
                                    successCompletion(jsonString as! [String : AnyObject],enMessage as String)
                                }else {
                                    successCompletion(jsonString as! [String : AnyObject],message as String)
                                }
                            }
                        }
                    }
                }else {
                    failureCompletion(LanguageHelper.getString(key: "Access failed"))
                }
            }
        }else {
            //post请求
            let url = URL(string: baseUrl + url)!
            let data = try? JSONSerialization.data(withJSONObject: self.parametersDic, options: [])
            let jsonStr = String(data: data!, encoding: String.Encoding.utf8)
            let jsonData = jsonStr!.data(using: .utf8, allowLossyConversion: false)!
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            Alamofire.request(request).responseJSON { (response) in
                if response.result.isSuccess {
                        if let jsonString = response.result.value {
                            let tempDic = (jsonString as! [String : AnyObject])
                            if !tempDic.keys.contains("error") {
                                let enMessage = (jsonString as! [String : AnyObject])["enMessage"] as! NSString
                                let message = (jsonString as! [String : AnyObject])["message"] as! NSString
                                if UserDefaults.standard.value(forKey: "languageStr") == nil {
                                    if FYTool.getLanguageType() == "en-CN" {
                                        successCompletion(jsonString as! [String : AnyObject],enMessage as String)
                                    }else {
                                        successCompletion(jsonString as! [String : AnyObject],message as String)
                                    }
                                }else {
                                    if UserDefaults.standard.value(forKey: "languageStr") as! String == "en" {
                                        successCompletion(jsonString as! [String : AnyObject],enMessage as String)
                                    }else {
                                        successCompletion(jsonString as! [String : AnyObject],message as String)
                                    }
                                }
                            }else {
                                let err = (jsonString as! [String : AnyObject])["error"] as! NSString
                                successCompletion(jsonString as! [String : AnyObject],err as String)
                            }
                        }
                    }else {
                        failureCompletion(LanguageHelper.getString(key: "Access failed"))
                    }
                }
            }
    }
    
}
