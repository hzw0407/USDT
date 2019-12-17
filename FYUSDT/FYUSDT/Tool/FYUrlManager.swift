//
//  FYUrlManager.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import Foundation

let testUrl = "/user/odtaWallet/permission/getUserWallet"
let test2 = "/market/market/getAllToken"

//验证邮箱
let verificationEmail = "/user/odtaUser/checkEmail"
//发送验证码
let sendCode = "/user/odtaUser/sendCode"
//注册
let Register = "/user/odtaUser/signUp"
//登录
let Login = "/user/odtaUser/userLogin"
//找回密码发送验证码
let findPassword_sendCode = "/user/odtaUser/forgetPassCode"
//重置密码
let resetPassword = "/user/odtaUser/forgetPassword"
//安全中心的重置密码
let safe_resetPassword = "/user/odtaUser/resetPassword?token=%@"
//钱包资产
let Wallet_Assets = "/user/odtaWallet/getUserWallet?token=%@"
//滚动信息
let Assets_InfoList = "/financial/product/getOrderLimit"
//提币信息
let withdrawInfo = "/wallet/walletInfo/getOdtaCoin?token=%@"
//提币申请
let withdrawApplication = "/user/odtaWallet/permission/transfer?token=%@"
//账单
let bill = "/user/exchange/list?token=%@"
