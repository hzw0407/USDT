//
//  FYMyTeamModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYMyTeamModel:HandyJSON {
    var uid:String?//用户id
    var email:String?//邮箱
    var balance:Double?//总资产
    var orderNum:Int?//订单数
    var getBalance:Double?//历史总收益
    var upBalance:Double?//为上级产生的收益
}
