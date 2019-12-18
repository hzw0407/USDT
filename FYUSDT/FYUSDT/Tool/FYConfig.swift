//
//  FYConfig.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

let iphoneXAfter =  (UIScreen.main.bounds.size.height > 736)

//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;
//导航栏高度
let navigationHeight = (statusBarHeight + 44)
//tabbar高度
let tabBarHeight = (statusBarHeight == 44 ? 83 : 49)
//顶部的安全距离
let topSafeAreaHeight = (statusBarHeight - 20)
//底部的安全距离
let bottomSafeAreaHeight = (tabBarHeight - 49)
//屏幕宽度
let FYScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
let FYScreenHeight = UIScreen.main.bounds.size.height

//token
let FYToken = "token"
//email
let FYEmail = "email"
