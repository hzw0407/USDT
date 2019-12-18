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
//抢单广场列表
let rushOrderList = "/financial/product/getProduct?token=%@"
//下单
let PlaceOrder = "/financial/product/save?token=%@"
//抢单详情
let rushOrderDetail = "/financial/product/getProductInfo?token=%@"
//订单列表
let orderList = "/financial/product/getOrderList?token=%@"
//查询最新的邀请码
let queryNewCode = "/user/InviteCodeLog/selectNewCodeByUser?token=%@"
//申请邀请码记录列表
let applicationList = "/user/InviteCodeLog/selectListByUser?token=%@"
//申请邀请码
let applicationinviteCode = "/user/InviteCodeLog/insert?token=%@"
//我的团队
let myTeamInfo = "/user/odtaUser/queryDownUser?token=%@"
