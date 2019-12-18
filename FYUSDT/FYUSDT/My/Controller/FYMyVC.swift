//
//  FYMyVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//  --我的

import UIKit

class FYMyVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FYMyCellDelegate {

    let dataArray:[[String: String]] = [
        ["image" : "bill", "name" : LanguageHelper.getString(key: "Bill management")],
        ["image" : "invite_code", "name" : LanguageHelper.getString(key: "Invite friends")],
        ["image" : "language", "name" : LanguageHelper.getString(key: "Language")],
        ["image" : "team", "name" : LanguageHelper.getString(key: "My team")],
        ["image" : "safe", "name" : LanguageHelper.getString(key: "Safety Center")],
        ["image" : "game", "name" : LanguageHelper.getString(key: "Game")],
        ["image" : "Social", "name" : LanguageHelper.getString(key: "Social contact")],
        ["image" : "Entertainment", "name" : LanguageHelper.getString(key: "Entertainment")],
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
        cell.delegate = self
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
        switch indexPath.row {
        case 0:
            //账单管理
            let vc = FYBillVC()
            vc.selectType = 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            //申请邀请码
            let vc = FYApplicationVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
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
        case 3:
            //我的团队
            let vc = FYMyTeamVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            //安全中心
            let vc = FYFindPasswordVC()
            vc.type = 2
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            //游戏
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "Coming soon"))
        case 6:
            //社交
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "Coming soon"))
        case 7:
            //娱乐
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "Coming soon"))
        default:
            break
        }
    }

    //pragma mark - CustomDelegate
    //注销登录
    func logout() {
        let alertController = UIAlertController.init(title: LanguageHelper.getString(key: "Reminder"), message: LanguageHelper.getString(key: "Are you sure you want to log out?"), preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Cancel"), style: UIAlertAction.Style.cancel, handler: nil)
        let confirmAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Confirm"), style: UIAlertAction.Style.default) { (action) in
            UserDefaults.standard.set(nil, forKey: FYToken)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "FYSetNewPasswordVC"), object: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }

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
        emailLabel.text = UserDefaults.standard.string(forKey: FYEmail)!
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
