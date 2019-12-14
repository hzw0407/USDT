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
        if InterfaceBaseDebug == 0 {
            baseUrl = "http://192.168.0.112:8088"
        }else {
            baseUrl = "http://192.168.0.112:8088"
        }
    }
    
    func addparameter(key:String,value:AnyObject) {
        self.parametersDic[key] = value as AnyObject
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
                        successCompletion(jsonString as! [String : AnyObject],"")
                    }
                }else {
                    failureCompletion("请求失败")
                }
            }
        }else {
            //post请求
            Alamofire.request(tempUrl, method: .post, parameters: self.parametersDic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        successCompletion(jsonString as! [String : AnyObject],"")
                    }
                }else {
                    failureCompletion("请求失败")
                }
            }
        }
    }
    
}
