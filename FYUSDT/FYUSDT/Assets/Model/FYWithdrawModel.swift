//
//  FYWithdrawModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/17.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYWithdrawModel:HandyJSON {
    var withdrawFee:Double?//手续费
    var availableAmount:Double?//可提金额
    var startAmount:Double?//起提金额
}
