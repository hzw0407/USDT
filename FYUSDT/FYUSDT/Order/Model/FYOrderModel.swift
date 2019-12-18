//
//  FYOrderModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYOrderModel:HandyJSON {
    var id:String?//产品id
    var demandAmount:Double?//需求金额
    var getAmount:Double?//产品已获得的金额
    var surplusAmount:Double?//剩余额度
    var startAmount:Double?//起投金额
    var rewardRate:Double?//预期收益率
    var useAmount:Double?//用户已投金额
    var rewardNum:Double?//预期收益
    var createTime:String?//下单时间
    var useNum:Int?//使用天数
    var pnum:Int?//参与人数
    var UseEndTime:String?//结算时间
}
