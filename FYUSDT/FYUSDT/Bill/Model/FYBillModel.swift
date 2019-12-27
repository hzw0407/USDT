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
    var type:Int?//类型：0：全部 1：充值  2：本金提现 3：投资收益  4 推荐奖励 5收益提现
    var createTime:String?//创建时间
    var status:Int?//提现状态（1,申请中  2 已确认  3已拒绝）（只有提现的记录这个字段才有值）
}
