//
//  FYHomeVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//  --首页

import UIKit
import HandyJSON

class FYHomeVC: UIViewController {
    
    var ceshiModel:temoModel?
    var modelArray:[testModel]?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orange
        self.testRquest()
    }
    
    func testRquest() {
        let requestManager = FYRequestManager.shared
//        requestManager.addparameter(key: "token", value: "93fdf35927ce4b330d7d2e88620cd9db" as AnyObject)
//        requestManager.request(type: requestType.get, url: testUrl, successCompletion: { (dict) in
//            if dict["code"]?.intValue == 200 {
//                self.ceshiModel = JSONDeserializer<temoModel>.deserializeFrom(dict: dict["data"] as? NSDictionary)
//                //转成json字符串输出 方便查看
//                print("转换后\(self.ceshiModel!.toJSONString(prettyPrint: true)!)")
//            }
//        }) { (errMessage) in
//
//        }
        requestManager.request(type: .post, url: test2, successCompletion: { (dict) in
            if dict["code"]?.intValue == 200 {
                self.modelArray = JSONDeserializer<testModel>.deserializeModelArrayFrom(array: dict["data"] as? NSArray) as! [testModel]
                print(self.modelArray!.toJSONString(prettyPrint: true)!)
            }
        }) { (errMessage) in
            
        }
    }

    //pragma mark - CustomMethod

    //pragma mark - ClickMethod

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    
    

    

}
