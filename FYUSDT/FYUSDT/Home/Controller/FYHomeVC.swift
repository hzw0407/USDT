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
    
    //下拉刷新
    let header = MJRefreshNormalHeader()
    //上拉加载更多
    let footer = MJRefreshAutoNormalFooter()
    //banner图数据数组
    var bannerArray:[String] = []
    //资讯数据模型数组
    var infoArray:[FYHomeModel] = []
    var page:Int = 1
    //总数据
    var totalNumber:Int = 0
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view).offset(0)
        }
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle(LanguageHelper.getString(key: "headRefresh1"), for: .idle)
        header.setTitle(LanguageHelper.getString(key: "headRefresh2"), for: .pulling)
        header.setTitle(LanguageHelper.getString(key: "headRefresh3"), for: .refreshing)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView.mj_header = header
        header.beginRefreshing()
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footRefresh))
        footer.setTitle(LanguageHelper.getString(key: "footerRefresh1"), for: .idle)
        self.tableView.mj_footer = footer
        
        self.getBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    //下拉刷新
    @objc func headerRefresh() {
        self.page = 1
        self.infoArray.removeAll()
        self.getInfoList()
    }
    
    //上拉加载更多
    @objc func footRefresh() {
        if self.infoArray.count >= self.totalNumber {
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "No more data yet"))
            self.tableView.mj_footer?.endRefreshing()
        }else {
            self.page += 1
            self.getInfoList()
        }
    }
    
    //获取banner图
    func getBanner() {
        var type:Int = 0
        if FYTool.getLanguageType() == "en-CN" {
            type = 2
        }else {
            type = 1
        }
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "currentPage", value: "\(self.page)" as AnyObject)
        manager.addparameter(key: "pageSize", value: "10" as AnyObject)
        manager.addparameter(key: "type", value: "2" as AnyObject)
        manager.addparameter(key: "language", value: type as AnyObject)
        manager.request(type: .post, url: newsList, successCompletion: { (dict, message) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if dict["code"]?.intValue == 200 {
                let tempArray = JSONDeserializer<FYHomeModel>.deserializeModelArrayFrom(array: dict["data"]!["list"] as? NSArray) as? [FYHomeModel]
                for tempModel in tempArray! {
                    self.bannerArray.append(tempModel.imgUrl ?? "")
                }
                self.tableView.reloadData()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //获取资讯列表
    func getInfoList() {
        var type:Int = 0
        if FYTool.getLanguageType() == "en-CN" {
            type = 2
        }else {
            type = 1
        }
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "currentPage", value: "\(self.page)" as AnyObject)
        manager.addparameter(key: "pageSize", value: "10" as AnyObject)
        manager.addparameter(key: "type", value: "1" as AnyObject)
        manager.addparameter(key: "language", value: type as AnyObject)
        manager.request(type: .post, url: newsList, successCompletion: { (dict, message) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if dict["code"]?.intValue == 200 {
                self.totalNumber = (dict["data"]!["total"] as? Int)!
                let tempArray = JSONDeserializer<FYHomeModel>.deserializeModelArrayFrom(array: dict["data"]!["list"] as? NSArray) as? [FYHomeModel]
                for tempModel in tempArray! {
                    self.infoArray.append(tempModel)
                }
                self.tableView.reloadData()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            MBProgressHUD.showInfo(errMessage)
        }
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //抢单
            let vc = FYLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
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
            return self.infoArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:FYAdvertisementCell = tableView.dequeueReusableCell(withIdentifier: "ADCell") as! FYAdvertisementCell
            cell.delegate = self as FYAdvertisementCellDelegate
            cell.imageArray = bannerArray
            return cell
        }else {
            let cell:FYInformationCell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! FYInformationCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let model = self.infoArray[indexPath.row]
            cell.refreshWithModel(model:model)
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
                make.width.equalTo(titleWidth + 20)
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
                make.right.equalTo(headerView).offset(-100)
                make.top.equalTo(headerView)
                make.height.equalTo(20)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.infoArray[indexPath.row]
        let vc = FYHomeDetailVC()
        vc.urlStr = model.h5Path
        self.navigationController?.pushViewController(vc, animated: true)
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
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYAdvertisementCell.self, forCellReuseIdentifier: "ADCell")
        tableView.register(FYInformationCell.self, forCellReuseIdentifier: "informationCell")
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView;
    }()
    

}
