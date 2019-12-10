//
//  tsetModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct temoModel:HandyJSON {
    var total_assets:Double?
    var total_oktc:Double?
    var userWallets:[temp1Model]?
}

struct temp1Model:HandyJSON {
    var balance:Double?
    var price:Double?
    var type:String?
    var total:Double?
    var cid:Int?
    var withdrawFee:Double?
}

struct testModel:HandyJSON {
    var id:Int?
    var tokenName:String?
    
}
