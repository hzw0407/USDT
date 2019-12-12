//
//  FYHomeVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//  --首页

import UIKit
import HandyJSON

class FYHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FYAdvertisementCellDelegate {
    
    var ceshiModel:temoModel?
    var modelArray:[testModel]?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.testRquest()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view).offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    func testRquest() {
            let requestManager = FYRequestManager.shared
    //        requestManager.addparameter(key: "token", value: "93fdf35927ce4b330d7d2e88620cd9db" as AnyObject)
    //        requestManager.request(type: requestType.get, url: testUrl, successCompletion: { (dict) in
    //            if dict["code"]?.intValue == 200 {
    //                self.ceshiModel = JSONDeserializer<temoModel>.deserializeFrom(dict: dict["data"] as? NSDictionary)
    //                //转成json字符串输出 方便查看
    //                print("转换后\(self.ceshiModel!.toJSONString(prettyPrint: true)!)")
    //            }
    //        }) { (errMessage) in
    //
    //        }
            requestManager.request(type: .post, url: test2, successCompletion: { (dict) in
                if dict["code"]?.intValue == 200 {
                    self.modelArray = JSONDeserializer<testModel>.deserializeModelArrayFrom(array: dict["data"] as? NSArray) as! [testModel]
    //                print(self.modelArray!.toJSONString(prettyPrint: true)!)
                }
            }) { (errMessage) in
                
            }
        }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //抢单
            let vc = FYLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 101 {
            //全部
        }
    }

    //pragma mark - SystemDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:FYAdvertisementCell = tableView.dequeueReusableCell(withIdentifier: "ADCell") as! FYAdvertisementCell
            cell.delegate = self as! FYAdvertisementCellDelegate
            cell.imageArray = [
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542274166859&di=4c518c688e6f1bf54c6e34e461c23888&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F5%2F57b40d52e787e.jpg",
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542274217900&di=e2d692fb3232d79fb4c42cdcd5913269&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D2526878758%2C1925171575%26fm%3D214%26gp%3D0.jpg",
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542274270063&di=f977235332c479eab625b3ba522b77c4&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fb90e7bec54e736d1cb2b2b2f90504fc2d56269d9.jpg",
                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542274383727&di=40b810e53893b74f2ea5d767d4e7cb17&imgtype=0&src=http%3A%2F%2Fpic33.nipic.com%2F20131008%2F9527735_184105459000_2.jpg"
            ]
            return cell
        }else {
            let cell:FYInformationCell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! FYInformationCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: FYScreenWidth, height: 120))
            //标题
            let titleLabel = UILabel.init()
            titleLabel.text = LanguageHelper.getString(key: "Home")
            titleLabel.textColor = FYColor.goldColor()
            titleLabel.font = UIFont.systemFont(ofSize: 35)
            headerView.addSubview(titleLabel)
            let titleWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Home"), font: UIFont.systemFont(ofSize: 35), height: 35)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(headerView).offset(15)
                make.width.equalTo(titleWidth)
                make.top.equalTo(headerView).offset(50)
                make.height.equalTo(35)
            }
            
            //去抢单
            let rushButton = UIButton.init()
            rushButton.setTitle(LanguageHelper.getString(key: "Rush"), for: .normal)
            rushButton.setImage(UIImage(named: "qd_select"), for: .normal)
            rushButton.setTitleColor(FYColor.goldColor(), for: .normal)
            rushButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            rushButton.setImagePosition(position: .left, spacing: 5)
            rushButton.layer.borderWidth = 1.0
            rushButton.layer.borderColor = FYColor.goldColor().cgColor
            rushButton.layer.cornerRadius = 35 / 2.0
            rushButton.tag = 100
            rushButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            headerView.addSubview(rushButton)
            rushButton.snp.makeConstraints { (make) in
                make.right.equalTo(headerView).offset(-15)
                make.top.equalTo(titleLabel.snp_top)
                make.width.equalTo(120)
                make.height.equalTo(titleLabel.snp_height)
            }
            return headerView
        }else {
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: FYScreenWidth, height: 40))
            //精选资讯
            let infomationLabel = UILabel.init()
            infomationLabel.text = LanguageHelper.getString(key: "Selected information")
            infomationLabel.textColor = FYColor.goldColor()
            infomationLabel.font = UIFont.systemFont(ofSize: 18)
            headerView.addSubview(infomationLabel)
            infomationLabel.snp.makeConstraints { (make) in
                make.left.equalTo(headerView).offset(15)
                make.width.equalTo(100)
                make.top.equalTo(headerView)
                make.height.equalTo(20)
            }
            //全部
            let allButton = UIButton.init()
            allButton.setTitle(LanguageHelper.getString(key: "All"), for: .normal)
            allButton.setTitleColor(FYColor.goldColor(), for: .normal)
            allButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            allButton.tag = 101
            allButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            headerView.addSubview(allButton)
            allButton.snp.makeConstraints { (make) in
                make.right.equalTo(headerView).offset(-15)
                make.width.equalTo(30)
                make.top.equalTo(headerView)
                make.height.equalTo(infomationLabel.snp_height)
            }
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 145
        }else {
            return 115
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }else {
            return 40
        }
    }

    //pragma mark - CustomDelegate
    //点击广告图
    func clickIndex(index: Int) {
//        print("点击的是第\(index)张")
    }

    //pragma mark - GetterAndSetter
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.mainColor()
        tableView.delegate = self as! UITableViewDelegate
        tableView.dataSource = self as! UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYAdvertisementCell.self, forCellReuseIdentifier: "ADCell")
        tableView.register(FYInformationCell.self, forCellReuseIdentifier: "informationCell")
        return tableView;
    }()
    

}
