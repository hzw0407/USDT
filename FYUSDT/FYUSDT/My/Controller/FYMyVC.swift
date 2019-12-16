//
//  FYMyVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//  --我的

import UIKit

class FYMyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let dataArray:[[String: String]] = [
        ["image" : "bill", "name" : LanguageHelper.getString(key: "Bill management")],
        ["image" : "invite_code", "name" : LanguageHelper.getString(key: "Invite friends")],
        ["image" : "language", "name" : LanguageHelper.getString(key: "Language")],
        ["image" : "", "name" : LanguageHelper.getString(key: "My team")],
        ["image" : "", "name" : LanguageHelper.getString(key: "Safety Center")],
        ["image" : "", "name" : LanguageHelper.getString(key: "Game")],
        ["image" : "", "name" : LanguageHelper.getString(key: "Social contact")],
        ["image" : "", "name" : LanguageHelper.getString(key: "Entertainment")],
        ["image" : "quit", "name" : LanguageHelper.getString(key: "Cancellation account")]
    ]
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view).offset(0)
            make.height.equalTo(300)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.headerView.snp_bottom)
            make.bottom.equalTo(self.view).offset(-bottomSafeAreaHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod

    //pragma mark - ClickMethod

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYMyCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let dict:[String : String] = self.dataArray[indexPath.row]
        cell.refreshWithRow(row: indexPath.row,dict: dict)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //账单管理
            let vc = FYBillVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            //申请邀请码
            let vc = FYApplicationVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            //切换语言
            if UserDefaults.standard.value(forKey: "languageStr") == nil {
                if FYTool.getLanguageType() == "en-CN" {
                    //设置成中文并记录
                    LanguageHelper.shareInstance.setLanguage(langeuage: "zh-Hans")
                    UserDefaults.standard.set("zh-Hans", forKey: "languageStr")
                    UserDefaults.standard.synchronize()
                }else {
                    //设置成英文并记录
                    LanguageHelper.shareInstance.setLanguage(langeuage: "en")
                    UserDefaults.standard.set("en", forKey: "languageStr")
                    UserDefaults.standard.synchronize()
                }
            }else {
                //之前在app里面设置过语言
                if UserDefaults.standard.value(forKey: "languageStr") as! String == "en" {
                    //设置成中文并记录
                    LanguageHelper.shareInstance.setLanguage(langeuage: "zh-Hans")
                    UserDefaults.standard.set("zh-Hans", forKey: "languageStr")
                    UserDefaults.standard.synchronize()
                }else {
                    //设置成英文并记录
                    LanguageHelper.shareInstance.setLanguage(langeuage: "en")
                    UserDefaults.standard.set("en", forKey: "languageStr")
                    UserDefaults.standard.synchronize()
                }
            }
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            AppDelegate.window?.rootViewController = FYTabbarVC()
        }else {
            //注销登录
        }
    }

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    lazy var headerView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.mainColor()
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "User center")
        titleLabel.textColor = FYColor.goldColor()
        titleLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(100)
            make.height.equalTo(35)
        }
        
        //头像
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage(named: "user_photo")
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.width.equalTo(50)
            make.top.equalTo(titleLabel.snp_bottom).offset(35)
            make.height.equalTo(50)
        }
        
        //邮箱
        let emailLabel = UILabel.init()
        emailLabel.text = "12345@qq.com"
        emailLabel.textColor = FYColor.goldColor()
        emailLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
            make.height.equalTo(20)
        }
        return view
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        tableView.layer.cornerRadius = 10.0
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYMyCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
}
