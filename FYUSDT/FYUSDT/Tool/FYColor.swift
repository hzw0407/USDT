//
//  FYColor.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

class FYColor: NSObject {
    static func rgb(_ red:CGFloat , _ green:CGFloat ,_ blue:CGFloat ,_ alpha:CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    //整体风格颜色
    static func mainColor() -> UIColor {
        return self.rgb(13, 13, 13, 1)
    }
    
    //土豪金颜色
    static func goldColor() -> UIColor {
        return FYTool.hexStringToUIColor(hexString: "#B1917F")
    }
    
    //键盘默认文字颜色
    static func placeholderColor() -> UIColor {
        return FYTool.hexStringToUIColor(hexString: "#4D4D4D")
    }
    
    //线的颜色
    static func lineColor() -> UIColor {
        return FYTool.hexStringToUIColor(hexString: "#EEEEEE")
    }
    
    //提币充币颜色
    static func operationColor() -> UIColor {
        return self.rgb(26, 26, 26, 1.0)
    }
    
    //立即抢单颜色
    static func rushColor() -> UIColor {
        return FYTool.hexStringToUIColor(hexString: "#4F230C")
    }
}
