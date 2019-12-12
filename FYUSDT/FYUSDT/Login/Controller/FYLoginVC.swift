//
//  FYLoginVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/11.
//  Copyright © 2019 何志武. All rights reserved.
//  --登录

import UIKit
import SnapKit

class FYLoginVC: UIViewController {
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
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(20.5)
            make.top.equalTo(self.view).offset(64)
            make.height.equalTo(20.5)
        }
        
        self.view.addSubview(self.regiserButton)
        self.regiserButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(40)
            make.top.equalTo(self.view).offset(66.5)
            make.height.equalTo(15)
        }
        
        self.view.addSubview(self.welcomeLabel)
        self.welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(164)
            make.height.equalTo(28.5)
        }
        
        self.view.addSubview(self.rushLabel)
        self.rushLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.welcomeLabel.snp_left)
            make.right.equalTo(self.welcomeLabel.snp_right)
            make.top.equalTo(self.welcomeLabel.snp_bottom).offset(5)
            make.height.equalTo(15)
        }
        
        self.view.addSubview(self.emailTextfield)
        self.emailTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.rushLabel.snp_left)
            make.right.equalTo(self.view).offset(-50)
            make.top.equalTo(self.rushLabel.snp_bottom).offset(75)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.correctImageView)
        self.correctImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(13.5)
            make.centerY.equalTo(self.emailTextfield.snp_centerY)
            make.height.equalTo(7)
        }
        
        self.view.addSubview(self.lineViewOne)
        self.lineViewOne.snp.makeConstraints { (make) in
            make.left.equalTo(self.emailTextfield.snp_left)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.emailTextfield.snp_bottom).offset(5)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(self.passwordTextfield)
        self.passwordTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.lineViewOne.snp_bottom).offset(33)
            make.height.equalTo(self.emailTextfield.snp_height)
        }
        
        self.view.addSubview(self.lineViewTwo)
        self.lineViewTwo.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewOne.snp_left)
            make.right.equalTo(self.lineViewOne.snp_right)
            make.top.equalTo(self.passwordTextfield.snp_bottom).offset(5)
            make.height.equalTo(0.2)
        }
        
        self.view.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineViewTwo.snp_left)
            make.right.equalTo(self.lineViewTwo.snp_right)
            make.top.equalTo(self.lineViewTwo.snp_bottom).offset(40)
            make.height.equalTo(44)
        }
        
        let width = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Forget password"), font: UIFont.systemFont(ofSize: 14), height: 15)
        self.view.addSubview(self.forgetButton)
        self.forgetButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.loginButton.snp_left)
            make.width.equalTo(width + 5)
            make.top.equalTo(self.loginButton.snp_bottom).offset(20)
            make.height.equalTo(15)
        }
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //关闭
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 101 {
            //注册
            let vc = FYRegisterVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 102 {
            //登录
        }else if btn.tag == 103 {
            //忘记密码
            let vc = FYFindPasswordVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    //关闭按钮
    lazy var closeButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "Login_Close"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //注册按钮
    lazy var regiserButton:UIButton = {
        let button = UIButton.init()
        button.setTitle(LanguageHelper.getString(key: "Register"), for: .normal)
        button.setTitleColor(FYColor.goldColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.tag = 101
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //欢迎回来
    lazy var welcomeLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Welcome back")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    //登录抢单大厅
    lazy var rushLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Log in to order grabbing Hall")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //邮箱输入框
    lazy var emailTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "input_email"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        textfield.clearButtonMode = .always
        //修改清除按钮的背景颜色 不然看不到
        let clearButton = textfield.value(forKey: "_clearButton") as! UIButton
        clearButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
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
    
    //密码输入框
    lazy var passwordTextfield:UITextField = {
        let textfield = UITextField.init()
        textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "input_password"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.textColor = UIColor.white
        return textfield
    }()
    
    //线
    lazy var lineViewTwo:UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = FYColor.lineColor()
        return lineView
    }()
    
    //登录按钮
    lazy var loginButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYColor.goldColor()
        button.setTitle(LanguageHelper.getString(key: "Login"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tag = 102
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //忘记密码
    lazy var forgetButton:UIButton = {
        let button = UIButton.init()
        button.setTitle(LanguageHelper.getString(key: "Forget password"), for: .normal)
        button.setTitleColor(FYColor.goldColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tag = 103
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()

}
