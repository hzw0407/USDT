//
//  FYHomeModel.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation
import HandyJSON

struct FYHomeModel:HandyJSON {
    var id:String?
    var createTime:String?//创建时间
    var h5Path:String?//详情链接
    var imgUrl:String?//benner图链接
    var text:String?//内容
    var title:String?//标题
}
