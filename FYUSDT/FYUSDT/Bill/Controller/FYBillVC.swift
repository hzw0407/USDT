//
//  FYBillVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --账单

enum sortType {
    case nomal//未选中
    case up//升序
    case down//降序
}

import UIKit
import HandyJSON

class FYBillVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //类型按钮数组
    let buttonNameArray:[[String:String]] = [["image" : "drop_down","name" : LanguageHelper.getString(key: "All")],
                                           ["image" : "nomal","name" : LanguageHelper.getString(key: "Amount")],
                                           ["image" : "down","name" : LanguageHelper.getString(key: "Time")]]
    var buttonArray:[UIButton] = []
    //所有的类型数组
    let allTypeArray:[String] = [LanguageHelper.getString(key: "All"),LanguageHelper.getString(key: "Recharge"),LanguageHelper.getString(key: "Withdraw"),LanguageHelper.getString(key: "Income from investment"),LanguageHelper.getString(key: "Recommended Award")]
    //金额排序方式 默认没选中
    var amountType:sortType = .nomal
    //时间排序方式 默认倒序
    var timeType:sortType = .down
    //全部按钮是否是选中状态
    var isSelectAll:Bool = false
    //选中的类型
    var selectType:Int?
    //数据模型数组
    var infoArray:[FYBillModel]?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view).offset(0)
            make.height.equalTo(200)
        }
        
        self.view.addSubview(self.selectTypeView)
        self.selectTypeView.snp.makeConstraints { (make) in
            make.leading.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.headerView.snp_bottom)
            make.height.equalTo(65)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.selectTypeView.snp_bottom).offset(-5)
            make.bottom.equalTo(self.view).offset(0)
        }
        
        self.view.addSubview(self.allTypeView)
        self.allTypeView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.width.equalTo(FYScreenWidth / 3)
            make.top.equalTo(self.tableView.snp_top)
            make.height.equalTo(40 * self.allTypeArray.count)
        }
        
        self.getBill()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    //获取账单信息
    func getBill() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "type", value: "\(self.selectType ?? 0)" as AnyObject)
        if self.amountType != .nomal && self.timeType == .nomal {
            manager.addparameter(key: "amountBy", value: (self.amountType == .up ? "2" : "1") as AnyObject)
        }
        if self.timeType != .nomal && self.amountType == .nomal {
            manager.addparameter(key: "timeBy", value: (self.timeType == .up ? "2" : "1") as AnyObject)
        }
        manager.request(type: .post, url: String(format: bill, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                self.infoArray = JSONDeserializer<FYBillModel>.deserializeModelArrayFrom(array: dict["data"] as? NSArray) as? [FYBillModel]
                self.tableView.reloadData()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }

    //pragma mark - ClickMethod
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnClick(btn:UIButton) {
        for tempButton in self.buttonArray {
            if tempButton.tag == btn.tag {
                btn.isSelected = true
            }else {
                tempButton.isSelected = false
            }
        }
        
        if btn.tag == 100 {
            //全部
            self.allTypeView.isHidden = self.isSelectAll
            self.isSelectAll = !self.isSelectAll
        }else if btn.tag == 101 {
            //金额
            if btn.isSelected {
                self.timeType = .nomal
                self.isSelectAll = false
                for tempButton in self.buttonArray {
                    if tempButton.tag == 102 {
                        tempButton.setImage(UIImage(named: "nomal"), for: .normal)
                    }
                }
                //选中状态
                if self.amountType == .up {
                    //升序变降序
                    self.amountType = .down
                    btn.setImage(UIImage(named: "down"), for: .normal)
                }else {
                    //降序变升序
                    self.amountType = .up
                    btn.setImage((UIImage(named: "up")), for: .normal)
                }
            }
        }else if btn.tag == 102 {
            //时间
            if btn.isSelected {
                self.amountType = .nomal
                self.isSelectAll = false
                for tempButton in self.buttonArray {
                    if tempButton.tag == 101 {
                        tempButton.setImage(UIImage(named: "nomal"), for: .normal)
                    }
                }
                //选中状态
                if self.timeType == .up {
                    //升序变降序
                    self.timeType = .down
                    btn.setImage(UIImage(named: "down"), for: .normal)
                }else {
                    //降序变升序
                    self.timeType = .up
                    btn.setImage((UIImage(named: "up")), for: .normal)
                }
            }
        }
        
        self.getBill()
    }
    
    //选择类型
    @objc func typeClick(btn:UIButton) {
        let typeStr = self.allTypeArray[btn.tag - 200]
        let allButton = self.buttonArray[0]
        allButton.setTitle(typeStr, for: .normal)
        self.allTypeView.isHidden = true
        self.isSelectAll = !self.isSelectAll
        self.selectType = btn.tag - 200
        
        self.getBill()
    }

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYBillCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let model = self.infoArray![indexPath.row] 
        cell.refreshWithModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "All records loaded")
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.textAlignment = .center
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view).offset(0)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    lazy var headerView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.mainColor()
        //返回按钮
        let backButton = UIButton.init()
        backButton.setImage(UIImage(named: "arrow_left"), for: .normal)
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(28.5)
            make.top.equalTo(view).offset(navigationHeight)
            make.height.equalTo(20)
        }
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "Bill")
        titleLabel.textColor = FYColor.goldColor()
        titleLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp_left)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(backButton.snp_bottom).offset(30)
            make.height.equalTo(35)
        }
        //提示
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "We will keep the last 7 days' bill records")
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.height.equalTo(15)
        }
        return view
    }()
    
    //选择类型
    lazy var selectTypeView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
        let buttonWidth = FYScreenWidth / 3
        for i in 0 ..< self.buttonNameArray.count {
            let dic:[String:String] = self.buttonNameArray[i]
            let button = UIButton.init()
            if i == 0 {
                if self.selectType == 1 {
                    //默认显示充值
                    button.setTitle(LanguageHelper.getString(key: "Recharge"), for: .normal)
                }else if self.selectType == 2 {
                    //默认显示提现
                    button.setTitle(LanguageHelper.getString(key: "Withdraw"), for: .normal)
                }else {
                    button.setTitle(dic["name"], for: .normal)
                }
            }
            button.setTitleColor(UIColor.gray, for: .normal)
            if i != 0 {
                //全部按钮不变色
                button.setTitle(dic["name"], for: .normal)
                button.setTitleColor(FYColor.goldColor(), for: .selected)
                button.setImage(UIImage(named: dic["image"]!), for: .normal)
                button.setImagePosition(position: .right, spacing: 20)
                if i == 2 {
                    //默认时间降序
                    button.isSelected = true
                }
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.tag = 100 + i
            button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            view.addSubview(button)
            self.buttonArray.append(button)
            button.snp.makeConstraints { (make) in
                make.left.equalTo(buttonWidth * CGFloat(i))
                make.width.equalTo(buttonWidth)
                make.top.bottom.equalTo(view).offset(0)
            }
        }
        
        return view
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYBillCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    //所有的类型
    lazy var allTypeView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        
        for i in 0 ..< self.allTypeArray.count {
            let typeStr = self.allTypeArray[i]
            let typeButton = UIButton.init()
            typeButton.setTitle(typeStr, for: .normal)
            typeButton.setTitleColor(UIColor.gray, for: .normal)
            typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            typeButton.contentHorizontalAlignment = .center
            typeButton.tag = 200 + i
            typeButton.addTarget(self, action: #selector(typeClick(btn:)), for: .touchUpInside)
            view.addSubview(typeButton)
            typeButton.snp.makeConstraints { (make) in
                make.left.right.equalTo(view).offset(0)
                make.top.equalTo(5 + 35 * i)
                make.height.equalTo(30)
            }
        }
        
        view.isHidden = true
        
        return view
    }()

}
