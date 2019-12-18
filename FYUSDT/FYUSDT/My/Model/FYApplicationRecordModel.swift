//
//  FYApplicationRecordModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYApplicationRecordModel:HandyJSON {
    var id:String?
    var userInviteCode:String?//邀请码，没有审核的为空
    var status:Int?//0 申请中  1审核拒绝  2 已发放   3   已使用
    var createTime:String?//申请时间
    var updateTime:String?//审核时间
}
