//
//  FYRushOrderVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//  --抢单

import UIKit
import HandyJSON

class FYRushOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FYRushOrderCellDelegate {

    //下拉刷新
    let header = MJRefreshNormalHeader()
    //上拉加载更多
    let footer = MJRefreshAutoNormalFooter()
    //数据模型数组
    var infoArray:[FYRushOrderModel] = []
    var page:Int = 1
    //总数据
    var totalNumber:Int = 0
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(navigationHeight)
            make.height.equalTo(35)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(40)
            make.bottom.equalTo(self.view).offset(-bottomSafeAreaHeight)
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
        
        //接收下单成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(headerRefresh), name: NSNotification.Name.init("FYRushOrderDetailVC"), object: nibName)
        
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
        self.listInfo()
    }
    
    //上拉加载更多
    @objc func footRefresh() {
        if self.infoArray.count >= self.totalNumber {
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "No more data yet"))
            self.tableView.mj_footer?.endRefreshing()
        }else {
            self.page += 1
            self.listInfo()
        }
    }
    
    //获取列表数据
    func listInfo() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "currentPage", value: "\(self.page)" as AnyObject)
        manager.addparameter(key: "pageSize", value: "10" as AnyObject)
        manager.request(type: .post, url: String(format: rushOrderList, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if dict["code"]?.intValue == 200 {
                self.totalNumber = (dict["data"]!["total"] as? Int)!
                let tempArray = JSONDeserializer<FYRushOrderModel>.deserializeModelArrayFrom(array: dict["data"]!["list"] as? NSArray) as? [FYRushOrderModel]
                for tempModel in tempArray! {
                    self.infoArray.append(tempModel)
                }
                self.tableView.reloadData()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            self.tableView.mj_header?.endRefreshing()
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //下单
//    func placeOrder(productId:String,amount:Int) {
//        let manager = FYRequestManager.shared
//        manager.clearparameter()
//        manager.addparameter(key: "productId", value: productId as AnyObject)
//        manager.addparameter(key: "useAmount", value: "\(amount)" as AnyObject)
//        manager.request(type: .post, url: String(format: PlaceOrder, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
//            if dict["code"]?.intValue == 200 {
//                MBProgressHUD.showInfo(LanguageHelper.getString(key: "PlaceOrder Success"))
//                self.tableView.mj_header?.beginRefreshing()
//            }else {
//                MBProgressHUD.showInfo(message)
//            }
//        }) { (errMessage) in
//            MBProgressHUD.showInfo(errMessage)
//        }
//    }

    //pragma mark - ClickMethod

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYRushOrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self as FYRushOrderCellDelegate
        let model = self.infoArray[indexPath.row]
        cell.refreshWithModel(model: model,index:indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.infoArray[indexPath.row]
        let vc = FYRushOrderDetailVC()
        vc.id = model.id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //pragma mark - CustomDelegate
    //倒计时结束刷新列表
    func countDownEnd() {
        self.tableView.mj_header?.beginRefreshing()
    }
    
    //点击抢单
    func rushClick(index: Int) {
        let model = self.infoArray[index]
        let vc = FYRushOrderDetailVC()
        vc.id = model.id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
//        let alertController = UIAlertController.init(title: LanguageHelper.getString(key: "Please enter the investment amount"), message: nil, preferredStyle: UIAlertController.Style.alert)
//        alertController.addTextField { (textfield) in
//            textfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "placeOrderTip"), attributes: [NSAttributedString.Key.foregroundColor : FYColor.placeholderColor(),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10)])
//            textfield.font = UIFont.systemFont(ofSize: 10)
//            textfield.textColor = UIColor.black
//            textfield.keyboardType = UIKeyboardType.numberPad
//        }
//        let cancelAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Cancel"), style: UIAlertAction.Style.cancel, handler: nil)
//        let confirmAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Confirm"), style: UIAlertAction.Style.default, handler: { (action) in
//            let textfield = alertController.textFields?.first
//            if Int((textfield!.text!))! < 100 {
//                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Less100"))
//            }else if Int((textfield!.text!))! % 100 != 0 {
//                MBProgressHUD.showInfo(LanguageHelper.getString(key: "integer"))
//            }else {
//                self.placeOrder(productId: model.id!, amount: Int((textfield!.text!))!)
//            }
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(confirmAction)
//        self.present(alertController, animated: true, completion: nil)
    }

    //pragma mark - GetterAndSetter
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Rush Order")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.mainColor()
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYRushOrderCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()

}
