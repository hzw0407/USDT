//
//  FYMyTeamVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/16.
//  Copyright © 2019 何志武. All rights reserved.
//  --我的团队

import UIKit
import HandyJSON

class FYMyTeamVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //下拉刷新
    let header = MJRefreshNormalHeader()
    //上拉加载更多
    let footer = MJRefreshAutoNormalFooter()
    //数据模型数组
    var listArray:[FYMyTeamModel] = []
    var page:Int = 1
    //总数据
    var totalNumber:Int = 0
    
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
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(28)
            make.top.equalTo(self.view).offset(navigationHeight)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view).offset(0)
            make.top.equalTo(self.backButton.snp_bottom)
        }
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle(LanguageHelper.getString(key: "Release and start refreshing"), for: .pulling)
        header.setTitle(LanguageHelper.getString(key: "Loading"), for: .refreshing)
        self.tableView.mj_header = header
        header.beginRefreshing()
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footRefresh))
        footer.setTitle(LanguageHelper.getString(key: "Pull-up Load More"), for: .pulling)
        footer.setTitle(LanguageHelper.getString(key: "Loading"), for: .refreshing)
        self.tableView.mj_footer = footer
    }
    
    //下拉刷新
    @objc func headerRefresh() {
        self.page = 1
        self.listArray.removeAll()
        self.getInfo()
    }
    
    //上拉加载更多
    @objc func footRefresh() {
        if self.listArray.count >= self.totalNumber {
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "No more data yet"))
            self.tableView.mj_footer?.endRefreshing()
        }else {
            self.page += 1
            self.getInfo()
        }
    }
    
    //获取数据
    func getInfo() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "currentPage", value: "\(self.page)" as AnyObject)
        manager.addparameter(key: "pageSize", value: "10" as AnyObject)
        manager.request(type: .post, url: String(format: myTeamInfo, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if dict["code"]?.intValue == 200 {
                self.totalNumber = (dict["data"]!["total"] as? Int)!
                let tempArray = JSONDeserializer<FYMyTeamModel>.deserializeModelArrayFrom(array: dict["data"]!["list"] as? NSArray) as? [FYMyTeamModel]
                for tempModel in tempArray! {
                    self.listArray.append(tempModel)
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
    @objc func btnClick() {
        self.navigationController?.popViewController(animated: true)
    }

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYMyTeamCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let model = self.listArray[indexPath.row]
        cell.refreshWithModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: FYScreenWidth, height: 65))
        
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "My team")
        titleLabel.textColor = FYColor.goldColor()
        titleLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(view).offset(15)
            make.height.equalTo(35)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    //返回按钮
    lazy var backButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "arrow_left"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.mainColor()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FYMyTeamCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()

}
