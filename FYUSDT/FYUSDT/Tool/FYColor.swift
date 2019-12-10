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
}
