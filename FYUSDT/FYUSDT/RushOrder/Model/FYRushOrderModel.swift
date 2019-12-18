//
//  FYRushOrderModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/17.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

//抢单列表模型
struct FYRushOrderModel:HandyJSON {
    var id:String?//产品ID
    var demandAmount:Double?//需求金额
    var getAmount:Double?//已经投资的金额
    var surplusAmount:Double?//剩余额度
    var startAmount:Double?//起投金额
    var rewardRate:Double?//预期收益率
    var timeNum:Int?//倒计时秒数
    var fundraisingStartTime:String?//募资开始时间
    var fundraisingEndTime:String?//募资结束时间
    var UseStartTime:String?//收益开始时间
    var UseEndTime:String?//收益结束时间
    var useNum:Int?//使用天数
}

//抢单详情模型
struct FYRushOrderDetailModel:HandyJSON {
    var id:String?//产品ID
    var demandAmount:Double?//需求金额
    var getAmount:Double?//已经投资的金额
    var surplusAmount:Double?//剩余额度
    var fundraisingStartTime:String?//募资开始时间
    var fundraisingEndTime:String?//募资结束时间
    var UseStartTime:String?//收益开始时间
    var UseEndTime:String?//收益结束时间
    var timeNum:Int?//产品募资结束倒计时
    var useNum:Int?//使用天数
    var startAmount:Double?//起投金额
    var rewardRate:Double?//预期收益率
    var availableBalance:Double?//可用余额
    var userGetAmount:Double?//用户已投金额
}
