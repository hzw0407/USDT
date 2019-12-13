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

        UITabBar.appearance().barTintColor = FYColor.mainColor()
        UITabBar.appearance().isTranslucent = false
        self.addChidVC()
    }
    
    func addChidVC() {
        let assetsVC = FYAssetsVC()
        assetsVC.title = LanguageHelper.getString(key: "Home")
        var normalIMageOne = UIImage(named: "home_normal")
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
        normalIMageOne = normalIMageOne!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        assetsVC.tabBarItem.image = normalIMageOne
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
        var selectImageOne = UIImage(named: "home_select")
        selectImageOne = selectImageOne!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        assetsVC.tabBarItem.selectedImage = selectImageOne
        assetsVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
        assetsVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], for: UIControl.State.selected)
        addChild(UINavigationController.init(rootViewController: assetsVC))
             
             
        let rushOrderVC = FYRushOrderVC()
        rushOrderVC.title = LanguageHelper.getString(key: "Rush Order")
        var normalIMageTwo = UIImage(named: "qd_normal")
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
        normalIMageTwo = normalIMageTwo!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        rushOrderVC.tabBarItem.image = normalIMageTwo
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
        var selectImageTwo = UIImage(named: "qd_select")
        selectImageTwo = selectImageTwo!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        rushOrderVC.tabBarItem.selectedImage = selectImageTwo
        rushOrderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
        rushOrderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], for: UIControl.State.selected)
        addChild(UINavigationController.init(rootViewController: rushOrderVC))
             
        let orderVC = FYOrderVC()
        orderVC.title = LanguageHelper.getString(key: "Order")
        var normalIMageThree = UIImage(named: "order_normal")
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
        normalIMageThree = normalIMageThree!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderVC.tabBarItem.image = normalIMageThree
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
        var selectImageThree = UIImage(named: "order_select")
        selectImageThree = selectImageThree!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderVC.tabBarItem.selectedImage = selectImageThree
        orderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
        orderVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], for: UIControl.State.selected)
        addChild(UINavigationController.init(rootViewController: orderVC))
             
        let myVC = FYMyVC()
        myVC.title = LanguageHelper.getString(key: "My")
        var normalIMageFour = UIImage(named: "user_normal")
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是灰色
        normalIMageFour = normalIMageFour!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myVC.tabBarItem.image = normalIMageFour
        //始终绘制图片原始状态，不使用Tint Color 不然绘制出来的会是蓝色
        var selectImageFour = UIImage(named: "user_select")
        selectImageFour = selectImageFour!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myVC.tabBarItem.selectedImage = selectImageFour
        myVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: UIControl.State.normal)
        myVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], for: UIControl.State.selected)
        addChild(UINavigationController.init(rootViewController: myVC))
    }
    

}
