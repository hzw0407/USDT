//
//  FYRegisterVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/11.
//  Copyright © 2019 何志武. All rights reserved.
//  --注册

import UIKit
import YYText
//#import <objc/runtime.h>

class FYRegisterVC: UIViewController,UITextFieldDelegate {

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
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view).offset(0)
        }
        
        self.scrollView.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView).offset(30)
            make.width.equalTo(20.5)
            make.top.equalTo(self.scrollView).offset(navigationHeight)
            make.height.equalTo(20.5)
        }
        
        self.scrollView.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(40)
            make.top.equalTo(self.scrollView).offset(navigationHeight)
            make.height.equalTo(15)
        }
        
        self.scrollView.addSubview(self.creatLabel)
        self.creatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
//            make.right.equalTo(self.view).offset(-30)
            make.right.equalTo(self.loginButton.snp_right)
            make.top.equalTo(self.closeButton.snp_bottom).offset(80)
            make.height.equalTo(28.5)
        }
        
        self.scrollView.addSubview(self.emailTextfield)
        self.emailTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatLabel.snp_left)
            make.right.equalTo(self.view).offset(-50)
            make.top.equalTo(self.creatLabel.snp_bottom).offset(97)
            make.height.equalTo(20)
        }
        
        self.scrollView.addSubview(self.correctImageView)
        self.correctImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(13.5)
            make.centerY.equalTo(self.emailTextfield.snp_centerY)
            make.height.equalTo(7)
        }
        
        self.scrollView.addSubview(self.lineViewOne)
        self.lineViewOne.snp.makeConstraints { (make) in
            make.left.equalTo(self.emailTextfield.snp_left)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.emailTextfield.snp_bottom).offset(5)
            make.height.equalTo(0.5)
        }

        self.scrollView.addSubview(self.codeTextfield)
        self.codeTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.lineViewOne.snp_bottom).offset(33)
            make.height.equalTo(self.emailTextfield.snp_height)
        }
        self.codeTextfield.layoutIfNeeded()
        self.codeTextfield.adjustsFontSizeToFitWidth = true
        //获取默认文字 在iOS13以后必须通过runtime机制去获取
        let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
        let placeLabel = object_getIvar(self.codeTextfield, ivar!) as! UILabel
        placeLabel.adjustsFontSizeToFitWidth = true

        self.scrollView.addSubview(self.lineViewTwo)
        self.lineViewTwo.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.codeTextfield.snp_bottom).offset(5)
            make.height.equalTo(self.lineViewOne.snp_height)
        }

        self.scrollView.addSubview(self.setPasswordTextfield)
        self.setPasswordTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTextfield.snp_left)
            make.right.equalTo(self.codeTextfield.snp_right)
            make.top.equalTo(self.lineViewTwo.snp_bottom).offset(33)
            make.height.equalTo(self.codeTextfield.snp_height)
        }

        self.scrollView.addSubview(self.lineViewThree)
        self.lineViewThree.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewTwo.snp_left)
            make.right.equalTo(self.lineViewTwo.snp_right)
            make.top.equalTo(self.setPasswordTextfield.snp_bottom).offset(5)
            make.height.equalTo(self.lineViewTwo.snp_height)
        }

        self.scrollView.addSubview(self.surePasswordTextfield)
        self.surePasswordTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.setPasswordTextfield.snp_left)
            make.right.equalTo(self.setPasswordTextfield.snp_right)
            make.top.equalTo(self.lineViewThree.snp_bottom).offset(33)
            make.height.equalTo(self.setPasswordTextfield.snp_height)
        }

        self.scrollView.addSubview(self.lineViewFour)
        self.lineViewFour.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewThree.snp_left)
            make.right.equalTo(self.lineViewThree.snp_right)
            make.top.equalTo(self.surePasswordTextfield.snp_bottom).offset(5)
            make.height.equalTo(self.lineViewThree.snp_height)
        }

        self.scrollView.addSubview(self.invateCodeTextfield)
        self.invateCodeTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.surePasswordTextfield.snp_left)
            make.right.equalTo(self.surePasswordTextfield.snp_right)
            make.top.equalTo(self.lineViewFour.snp_bottom).offset(33)
            make.height.equalTo(self.surePasswordTextfield.snp_height)
        }

        self.scrollView.addSubview(self.lineViewFive)
        self.lineViewFive.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewFour.snp_left)
            make.right.equalTo(self.lineViewFour.snp_right)
            make.top.equalTo(self.invateCodeTextfield.snp_bottom).offset(5)
            make.height.equalTo(self.lineViewFour.snp_height)
        }

        self.scrollView.addSubview(self.checklistButton)
        self.checklistButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewFive.snp_left)
            make.width.equalTo(20)
            make.top.equalTo(self.lineViewFive.snp_bottom).offset(20)
            make.height.equalTo(20)
        }

        self.scrollView.addSubview(self.agreementLabel)
        self.agreementLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.checklistButton.snp_right).offset(5)
            make.right.equalTo(self.scrollView)
            make.top.equalTo(self.checklistButton.snp_top)
            make.height.equalTo(20)
        }
        
        self.scrollView.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewFive.snp_left)
            make.right.equalTo(self.lineViewFive.snp_right)
            make.top.equalTo(self.checklistButton.snp_bottom).offset(40)
            make.height.equalTo(44)
        }
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: 700 > FYScreenHeight ? 700 : FYScreenHeight)
    }
    
    //验证邮箱
    func checkEmail() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "email", value: self.emailTextfield.text as AnyObject)
        manager.request(type: .get, url: verificationEmail, successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                self.correctImageView.isHidden = false
            }else {
                self.correctImageView.isHidden = true
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //获取验证码
    func getCode() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "email", value: self.emailTextfield.text as AnyObject)
        manager.addparameter(key: "flag", value: "1" as AnyObject)
        manager.request(type: .post, url: sendCode, successCompletion: { (dict, message) in
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
    
    //注册
    func register() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "email", value: self.emailTextfield.text as AnyObject)
        manager.addparameter(key: "ecode", value: self.codeTextfield.text as AnyObject)
        manager.addparameter(key: "password", value: self.setPasswordTextfield.text as AnyObject)
        manager.addparameter(key: "rePassword", value: self.surePasswordTextfield.text as AnyObject)
        manager.addparameter(key: "inviteCode", value: self.invateCodeTextfield.text as AnyObject)
        manager.request(type: .post, url: Register, successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Register Success"))
                self.navigationController?.popViewController(animated: true)
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
        if btn.tag == 100 || btn.tag == 101 {
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 102 {
            //获取验证码
            self.getCode()
        }else if btn.tag == 103 {
            //勾选协议
            btn.isSelected = !btn.isSelected
        }else if btn.tag == 104 {
            //下一步
            if self.emailTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Email"))
            }else if self.codeTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Code"))
            }else if self.setPasswordTextfield.text!.count <= 0 || self.surePasswordTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Password"))
            }else if self.setPasswordTextfield.text != self.surePasswordTextfield.text {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Password Inconsistent"))
            }else if self.invateCodeTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Empty Invate"))
            }else if !self.checklistButton.isSelected {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Agreement Service"))
            }else {
                self.register()
            }
        }
    }

    //pragma mark - SystemDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextfield && textField.text!.count > 0 {
            self.checkEmail()
        }
    }

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //关闭按钮
    lazy var closeButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "Login_Close"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //注册按钮
    lazy var loginButton:UIButton = {
        let button = UIButton.init()
        button.setTitle(LanguageHelper.getString(key: "Login"), for: .normal)
        button.setTitleColor(FYColor.goldColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.tag = 101
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //创建新账户
    lazy var creatLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Creat")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    //邮箱输入框
    lazy var emailTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "input_email"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.clearButtonMode = .always
        //修改清除按钮的图片 不然看不到
        let clearButton = textfield.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "delete"), for: .normal)
        textfield.delegate = self
        return textfield;
    }()
    
    //邮箱正确图片
    lazy var correctImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "Login_Right")
        imageView.isHidden = true
        return imageView
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
        let rightButton = UIButton(type: .custom)
        rightButton.backgroundColor = FYColor.goldColor()
        rightButton.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.layer.cornerRadius = 5.0
        rightButton.clipsToBounds = true
        rightButton.frame = CGRect(x: 0, y: 0, width: rightButtonWidth + 5, height: 20)
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
    
    //设置密码输入框
    lazy var setPasswordTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "set_password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    //线
    lazy var lineViewThree:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //确认密码输入框
    lazy var surePasswordTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "sure_password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    //线
    lazy var lineViewFour:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //邀请码输入框
    lazy var invateCodeTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "invateCode"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        return textfield
    }()
    
    //线
    lazy var lineViewFive:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //勾选按钮
    lazy var checklistButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "Register_NoSelect"), for: .normal)
        button.setImage(UIImage(named: "Register_Select"), for: .selected)
        button.isSelected = false
        button.tag = 103
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //用户协议
    lazy var agreementLabel:YYLabel = {
        let label = YYLabel.init()
        let agreeString = LanguageHelper.getString(key: "Agreement")
        let attribute = NSMutableAttributedString(string: agreeString)
        var range:NSRange?
        if FYTool.getLanguageType() == "en-CN" {
            range = NSRange(location: 28, length: attribute.length - 28)
            attribute.yy_setColor(FYColor.placeholderColor(), range: NSRange(location: 0, length: 29))
        }else {
            range = NSRange(location: 7, length: 6)
            attribute.yy_setColor(FYColor.placeholderColor(), range: NSRange(location: 0, length: 7))
        }
        attribute.yy_font = UIFont.systemFont(ofSize: 14)
        attribute.yy_setColor(FYColor.goldColor(), range: range!)
        attribute.yy_setTextHighlight(range!, color: FYColor.goldColor(), backgroundColor: UIColor.clear) { (view, text, range, rect) in
            print("点击了协议")
        }
        label.attributedText = attribute
        return label
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
