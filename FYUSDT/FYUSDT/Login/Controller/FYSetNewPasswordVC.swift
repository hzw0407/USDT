//
//  FYSetNewPasswordVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/16.
//  Copyright © 2019 何志武. All rights reserved.
//  --设置新密码

import UIKit

class FYSetNewPasswordVC: UIViewController {
    
    //1登录进来 2安全中心进来
    public var type:Int?
    //邮箱
    public var email:String?
    //验证码
    public var code:String?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.creatUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    func creatUI() {
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(30)
            make.top.equalTo(self.view).offset(110)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.setLabel)
        self.setLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backButton.snp_left)
            make.right.equalTo(self.view)
            make.top.equalTo(self.backButton.snp_bottom).offset(80)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.tipLabel)
        self.tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.setLabel.snp_left)
            make.right.equalTo(self.setLabel.snp_right)
            make.top.equalTo(self.setLabel.snp_bottom).offset(10)
            make.height.equalTo(15)
        }
        
        if self.type == 2 {
            self.view.addSubview(self.oldPasswordTextfield)
            self.oldPasswordTextfield.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(30)
                make.right.equalTo(self.view).offset(-30)
                make.top.equalTo(self.tipLabel.snp_bottom).offset(70)
                make.height.equalTo(15)
            }
            
            self.view.addSubview(self.lineViewOne)
            self.lineViewOne.snp.makeConstraints { (make) in
                make.left.equalTo(self.oldPasswordTextfield.snp_left)
                make.right.equalTo(self.oldPasswordTextfield.snp_right)
                make.top.equalTo(self.oldPasswordTextfield.snp_bottom).offset(10)
                make.height.equalTo(0.5)
            }
        }
        
        
        self.view.addSubview(self.passWordTextfield)
        self.passWordTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.tipLabel.snp_bottom).offset(80)
            make.height.equalTo(15)
        }
        
        self.view.addSubview(self.lineViewTwo)
        self.lineViewTwo.snp.makeConstraints { (make) in
            make.left.equalTo(self.passWordTextfield.snp_left)
            make.right.equalTo(self.passWordTextfield.snp_right)
            make.top.equalTo(self.passWordTextfield.snp_bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(self.confirmTextfield)
        self.confirmTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewTwo.snp_left)
            make.right.equalTo(self.lineViewTwo.snp_right)
            make.top.equalTo(self.lineViewTwo.snp_bottom).offset(30)
            make.height.equalTo(self.passWordTextfield.snp_height)
        }
        
        self.view.addSubview(self.lineViewThree)
        self.lineViewThree.snp.makeConstraints { (make) in
            make.left.equalTo(self.confirmTextfield.snp_left)
            make.right.equalTo(self.confirmTextfield.snp_right)
            make.top.equalTo(self.confirmTextfield.snp_bottom).offset(10)
            make.height.equalTo(self.lineViewTwo.snp_height)
        }
        
        self.view.addSubview(self.modifyButton)
        self.modifyButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewThree.snp_left)
            make.right.equalTo(self.lineViewThree.snp_right)
            make.top.equalTo(self.lineViewThree.snp_bottom).offset(40)
            make.height.equalTo(45)
        }
        
        if self.type == 2 {
            self.passWordTextfield.snp.remakeConstraints { (make) in
                make.left.equalTo(self.lineViewOne.snp_left)
                make.right.equalTo(self.lineViewOne.snp_right)
                make.top.equalTo(self.lineViewOne.snp_bottom).offset(30)
                make.height.equalTo(self.oldPasswordTextfield.snp_height)
            }
        }
        
    }
    
    //修改密码
    func modifyPassword() {
        if self.type == 1 {
            //登录进来
            let manager = FYRequestManager.shared
            manager.addparameter(key: "email", value: self.email as AnyObject)
            manager.addparameter(key: "ecode", value: self.code as AnyObject)
            manager.addparameter(key: "password", value: self.passWordTextfield.text as AnyObject)
            manager.addparameter(key: "rePassword", value: self.confirmTextfield.text as AnyObject)
            manager.request(type: .post, url: resetPassword, successCompletion: { (dict, message) in
                if dict["code"]?.intValue == 200 {
                    MBProgressHUD.showInfo(LanguageHelper.getString(key: "Password changed successfully"))
                    UserDefaults.standard.set("", forKey: FYToken)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "FYSetNewPasswordVC"), object: nil)
                }else {
                    MBProgressHUD.showInfo(message)
                }
            }) { (errMessage) in
                MBProgressHUD.showInfo(errMessage)
            }
        }else {
            //安全中心进来
            let manager = FYRequestManager.shared
            manager.addparameter(key: "email", value: self.email as AnyObject)
            manager.addparameter(key: "ecode", value: self.code as AnyObject)
            manager.addparameter(key: "password", value: self.oldPasswordTextfield.text as AnyObject)
            manager.addparameter(key: "newPassword", value: self.passWordTextfield.text as AnyObject)
            manager.addparameter(key: "reNewPassword", value: self.confirmTextfield.text as AnyObject)
            manager.request(type: .post, url: String(format: safe_resetPassword, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
                if dict["code"]?.intValue == 200 {
                    MBProgressHUD.showInfo(LanguageHelper.getString(key: "Password changed successfully"))
                    UserDefaults.standard.set("", forKey: FYToken)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "FYSetNewPasswordVC"), object: nil)
                }else {
                    MBProgressHUD.showInfo(message)
                }
            }) { (errMessage) in
                MBProgressHUD.showInfo(errMessage)
            }
        }
        
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //返回
            self.navigationController?.popViewController(animated: true)
        }else {
            //确认修改
            if self.passWordTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Password"))
            }else if self.confirmTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty NewPassword"))
            }else if self.passWordTextfield.text != self.confirmTextfield.text {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Password Inconsistent"))
            }else {
                if self.type == 2 && self.oldPasswordTextfield.text!.count <= 0 {
                    MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty OldPassword"))
                }else {
                    self.modifyPassword()
                }
            }
        }
    }

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    //返回按钮
    lazy var backButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //设置新密码标题
    lazy var setLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Set new password")
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    //提示
    lazy var tipLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "SetTip")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //旧密码输入框
    lazy var oldPasswordTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "Please enter the old password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.isSecureTextEntry = true
        return textfield;
    }()
    
    //线
    lazy var lineViewOne:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //密码输入框
    lazy var passWordTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "Please set a new password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.isSecureTextEntry = true
        return textfield;
    }()
    
    //线
    lazy var lineViewTwo:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //确认密码输入框
    lazy var confirmTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "Please confirm the new password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.isSecureTextEntry = true
        return textfield;
    }()
    
    //线
    lazy var lineViewThree:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //确认修改
    lazy var modifyButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYColor.goldColor()
        button.setTitle(LanguageHelper.getString(key: "Confirm revision"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tag = 200
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()

}
