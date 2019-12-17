//
//  FYAssetsModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/17.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

//资产模型
struct FYAssetsModel:HandyJSON {
    var balance:Double?//钱包总余额
    var getBalance:Double?//历史总收益
}

//滚动消息模型
struct FYInfoModel:HandyJSON {
    var id:String?
    var email:String?
}
