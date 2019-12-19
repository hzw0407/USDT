//
//  AppDelegate.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyFitsize

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //初始化语言
        LanguageHelper.shareInstance.initUserLanguage()
        //初始化默认适配尺寸
        SwiftyFitsize.reference(width: 414, iPadFitMultiple: 0.5)
        
        //初始化自动键盘管理
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = (UIScreen.main.bounds.size.height / 900) * 210
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        self.setupGlobalUIStyle()
        self.setRootViewController()
        window?.makeKeyAndVisible()
        
        //接收登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController), name: NSNotification.Name.init(rawValue: "FYLoginVC"), object: nil)
        //接收修改密码成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController), name: NSNotification.Name.init("FYSetNewPasswordVC"), object: nil)
        
        return true
    }
    
    func setupGlobalUIStyle() -> Void {
        let appearanceBar = UINavigationBar.appearance()
        appearanceBar.tintColor = UIColor.black
        appearanceBar.isTranslucent = false
        appearanceBar.barTintColor = UIColor.white
        appearanceBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.black]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -200, vertical: 0), for: UIBarMetrics.default)
    }
    
    @objc func setRootViewController() {
        if UserDefaults.standard.string(forKey: FYToken) != nil {
            //已登录
            window?.rootViewController = FYTabbarVC()
        }else {
            //未登录
            window?.rootViewController = UINavigationController.init(rootViewController: FYHomeVC())
        }
    }


}

