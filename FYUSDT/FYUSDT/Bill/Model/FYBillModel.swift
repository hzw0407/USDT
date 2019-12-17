//
//  FYBillModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/17.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYBillModel:HandyJSON {
    var amount:Double?//金额
    var type:Int?//类型：0：全部 1：充值  2：提现 3：投资收益  4 推荐奖励
    var createTime:String?//创建时间
}
