//
//  FYAssetsModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/17.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYAssetsModel:HandyJSON {
    var balance:Double?//钱包总余额
    var getBalance:Double?//历史总收益
}
