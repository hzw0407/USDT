//
//  FYTabbarVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

class FYTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChidVC()
    }
    
    func addChidVC() {
        let homeVC = FYLoginVC()
        homeVC.title = "首页"
//        homeVc.title = LanguageHelper.getString(key: "home_pager")
//        var normalIMageOne = UIImage(named: "icon_tab1")
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
//        normalIMageOne = normalIMageOne!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        homeVc.tabBarItem.image = normalIMageOne
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
//        var selectImageOne = UIImage(named: "icon_select_tab1")
//        selectImageOne = selectImageOne!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        homeVc.tabBarItem.selectedImage = selectImageOne
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = UIColor.black
        }else {
            homeVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
            homeVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        }
        addChild(UINavigationController.init(rootViewController: homeVC))
             
             
        let rushOrderVC = FYRushOrderVC()
        rushOrderVC.title = "抢单"
//        marketVc.title = LanguageHelper.getString(key: "Quotation")
//        var normalIMageTwo = UIImage(named: "icon_tab2")
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
//        normalIMageTwo = normalIMageTwo!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        marketVc.tabBarItem.image = normalIMageTwo
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
//        var selectImageTwo = UIImage(named: "icon_select_tab2")
//        selectImageTwo = selectImageTwo!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        marketVc.tabBarItem.selectedImage = selectImageTwo
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = UIColor.black
        }else {
            rushOrderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
            rushOrderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        }
        addChild(UINavigationController.init(rootViewController: rushOrderVC))
             
        let orderVC = FYOrderVC()
        orderVC.title = "订单"
//        contractVC.title = LanguageHelper.getString(key: "Contract")
//        var normalIMageThree = UIImage(named: "icon_tab5")
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
//        normalIMageThree = normalIMageThree!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        contractVC.tabBarItem.image = normalIMageThree
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
//        var selectImageThree = UIImage(named: "icon_select_tab5")
//        selectImageThree = selectImageThree!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        contractVC.tabBarItem.selectedImage = selectImageThree
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = UIColor.black
        }else {
            orderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
            orderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        }
        addChild(UINavigationController.init(rootViewController: orderVC))
             
        let myVC = FYMyVC()
        myVC.title = "我的"
//        transctVc.title = LanguageHelper.getString(key: "information")
//        var normalIMageFour = UIImage(named: "icon_tab3")
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
//        normalIMageFour = normalIMageFour!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        transctVc.tabBarItem.image = normalIMageFour
//        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
//        var selectImageFour = UIImage(named: "icon_select_tab3")
//        selectImageFour = selectImageFour!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        transctVc.tabBarItem.selectedImage = selectImageFour
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = UIColor.black
        }else {
            myVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
            myVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        }
        addChild(UINavigationController.init(rootViewController: myVC))
    }
    

}
