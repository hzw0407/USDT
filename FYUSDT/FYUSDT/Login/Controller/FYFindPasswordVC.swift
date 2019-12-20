//
//  FYFindPasswordVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/11.
//  Copyright © 2019 何志武. All rights reserved.
//  --找回密码

import UIKit

class FYFindPasswordVC: UIViewController {
    
    //1登录进来 2安全中心进来
    public var type:Int?
    var countDown = 60
    var timer:Timer?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        self.creatUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    //pragma mark - CustomMethod
    func creatUI() {
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(30)
            make.top.equalTo(self.view).offset(navigationHeight)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.findPasswordLabel)
        self.findPasswordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backButton.snp_left)
            make.right.equalTo(self.view)
            make.top.equalTo(self.backButton.snp_bottom).offset(63)
            make.height.equalTo(28)
        }
        
        self.view.addSubview(self.emailTextfield)
        self.emailTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.findPasswordLabel.snp_bottom).offset(96)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.lineViewOne)
        self.lineViewOne.snp.makeConstraints { (make) in
            make.left.equalTo(self.emailTextfield.snp_left)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.emailTextfield.snp_bottom).offset(5)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(self.codeTextfield)
        self.codeTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.lineViewOne.snp_bottom).offset(33)
            make.height.equalTo(self.emailTextfield.snp_height)
        }
        //获取默认文字 在iOS13以后必须通过runtime机制去获取
        let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
        let placeLabel = object_getIvar(self.codeTextfield, ivar!) as! UILabel
        placeLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(self.lineViewTwo)
        self.lineViewTwo.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.codeTextfield.snp_bottom).offset(5)
            make.height.equalTo(self.lineViewOne.snp_height)
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewTwo.snp_left)
            make.right.equalTo(self.lineViewTwo.snp_right)
            make.top.equalTo(self.lineViewTwo.snp_bottom).offset(40)
            make.height.equalTo(44)
        }
    }
    
    //发送验证码
    func sendCode() {
        let manager = FYRequestManager.shared
        manager.addparameter(key: "email", value: self.emailTextfield.text as AnyObject)
        manager.request(type: .post, url: findPassword_sendCode, successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Send Success"))
                let button = self.codeTextfield.viewWithTag(102) as! UIButton
                button.isEnabled = false
                if self.timer == nil {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.refreshTime), userInfo: nil, repeats: true)
                }
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //刷新倒计时
    @objc func refreshTime() {
        self.countDown -= 1
        let button = self.codeTextfield.viewWithTag(102) as! UIButton
        button.setTitle(String(format: "%zds", self.countDown), for: .normal)
        if self.countDown <= 0 {
            self.timer?.invalidate()
            self.timer = nil
            button.isEnabled = true
            button.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
            self.countDown = 60
        }
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //返回
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 102 {
            //发送验证码
            self.sendCode()
        }else if btn.tag == 104 {
            //下一步
            if self.emailTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Email"))
            }else if self.codeTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Code"))
            }else {
                let vc = FYSetNewPasswordVC()
                vc.email = self.emailTextfield.text
                vc.code = self.codeTextfield.text
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: true)
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
    
    //密码找回
    lazy var findPasswordLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Password back")
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    //邮箱输入框
    lazy var emailTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "input_email"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        return textfield;
    }()
    
    //线
    lazy var lineViewOne:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //验证码输入框
    lazy var codeTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "input_code"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        let rightButtonWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "get_code"), font: UIFont.systemFont(ofSize: 14), height: 20)
        let rightButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: rightButtonWidth + 5, height: 20))
        rightButton.backgroundColor = FYColor.goldColor()
        rightButton.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.tag = 102
        rightButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        textfield.rightView = rightButton
        textfield.rightViewMode = .always
        return textfield
    }()
    
    //线
    lazy var lineViewTwo:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //下一步
    lazy var nextButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYColor.goldColor()
        button.setTitle(LanguageHelper.getString(key: "Next step"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tag = 104
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()

}
