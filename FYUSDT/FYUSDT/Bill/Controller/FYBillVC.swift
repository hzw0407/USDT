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

class FYBillVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let buttonNameArray:[[String:String]] = [["image" : "","name" : LanguageHelper.getString(key: "All")],
                                           ["image" : "nomal","name" : LanguageHelper.getString(key: "Amount")],
                                           ["image" : "down","name" : LanguageHelper.getString(key: "Time")]]
    var buttonArray:[UIButton] = []
    var amountType:sortType?//金额排序方式
    var timeType:sortType?//时间排序方式
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view).offset(0)
            make.height.equalTo(200)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.headerView.snp_bottom)
            make.bottom.equalTo(self.view).offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod

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
            for tempButton in self.buttonArray {
                if tempButton.tag == 101 || tempButton.tag == 102 {
                    //将金额和时间的状态都改为未选中
                    tempButton.setImage(UIImage(named: "nomal"), for: .normal)
                    self.timeType = .nomal
                    self.amountType = .nomal
                }
            }
        }else if btn.tag == 101 {
            //金额
            if btn.isSelected {
                self.timeType = .nomal
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
        
    }

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYBillCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: FYScreenWidth, height: 65))
        let buttonWidth = FYScreenWidth / 3
        for i in 0 ..< self.buttonNameArray.count {
            let dic:[String:String] = self.buttonNameArray[i]
            let button = UIButton.init()
            button.setTitle(dic["name"], for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(FYColor.goldColor(), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            if i != 0 {
                button.setImage(UIImage(named: dic["image"]!), for: .normal)
                button.setImagePosition(position: .right, spacing: 20)
                if i == 2 {
                    //默认时间降序
                    button.isSelected = true
                    self.timeType = .down
                }else {
                    self.amountType = .nomal
                }
            }
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
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
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
            make.top.equalTo(view).offset(55)
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
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        tableView.layer.cornerRadius = 10.0
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(FYBillCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

}
