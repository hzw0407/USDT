//
//  FYApplicationVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --申请邀请码

import UIKit

class FYApplicationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
            make.top.equalTo(self.view).offset(50)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.backButton.snp_bottom)
            make.bottom.equalTo(self.view).offset(0)
        }
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: 770 > FYScreenHeight ? 770 : FYScreenHeight)
        
        self.view.addSubview(self.successView)
        self.successView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(320)
        }
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 301 {
            UIPasteboard.general.string = btn.titleLabel?.text!
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "copy_success"))
        }else if btn.tag == 302 {
            //申请邀请码
        }else if btn.tag == 400 {
            //关闭申请成功view
            self.successView.isHidden = true
        }else if btn.tag == 401 {
            //返回查看
            self.successView.isHidden = true
        }
    }

    //pragma mark - SystemDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FYApplicationCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Application record")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(20)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    //返回按钮
    lazy var backButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "arrow_left"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        //上半部
        let headeerView = UIView.init()
        headeerView.backgroundColor = FYColor.mainColor()
        headeerView.tag = 200
        scrollView.addSubview(headeerView)
        headeerView.snp.makeConstraints { (make) in
            make.left.top.equalTo(scrollView).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.height.equalTo(190)
        }
        
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "Application invitation code")
        titleLabel.textColor = FYColor.goldColor()
        titleLabel.font = UIFont.systemFont(ofSize: 35)
        headeerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headeerView).offset(20)
            make.right.equalTo(headeerView).offset(0)
            make.top.equalTo(headeerView).offset(30)
            make.height.equalTo(35)
        }
        
        //头像
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage(named: "user_photo")
        headeerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.width.equalTo(50)
            make.top.equalTo(titleLabel.snp_bottom).offset(35)
            make.height.equalTo(50)
        }
        
        //账号标题
        let accountTitleLabel = UILabel.init()
        accountTitleLabel.text = LanguageHelper.getString(key: "Your account number")
        accountTitleLabel.textColor = UIColor.gray
        accountTitleLabel.font = UIFont.systemFont(ofSize: 15)
        headeerView.addSubview(accountTitleLabel)
        accountTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.right.equalTo(headeerView).offset(0)
            make.top.equalTo(iconImageView.snp_top)
            make.height.equalTo(15)
        }
        
        let accountLabel = UILabel.init()
        accountLabel.text = "12345@qq.com"
        accountLabel.textColor = FYColor.goldColor()
        accountLabel.font = UIFont.systemFont(ofSize: 15)
        accountLabel.tag = 201
        headeerView.addSubview(accountLabel)
        accountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(accountTitleLabel.snp_left)
            make.right.equalTo(accountTitleLabel.snp_right)
            make.bottom.equalTo(iconImageView.snp_bottom)
            make.height.equalTo(accountTitleLabel.snp_height)
        }
        
        //中间部分
        let middleView = UIView.init()
        middleView.backgroundColor = FYTool.hexStringToUIColor(hexString: "#E32959")
        middleView.layer.cornerRadius = 5.0
        middleView.clipsToBounds = true
        middleView.tag = 300
        scrollView.addSubview(middleView)
        middleView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.top.equalTo(headeerView.snp_bottom)
            make.height.equalTo(200)
        }
        
        //最新邀请码
        let latestLabel = UILabel.init()
        latestLabel.text = LanguageHelper.getString(key: "Latest")
        latestLabel.textColor = UIColor.white
        latestLabel.font = UIFont.systemFont(ofSize: 15)
        latestLabel.textAlignment = .center
        middleView.addSubview(latestLabel)
        latestLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(middleView).offset(0)
            make.top.equalTo(middleView).offset(25)
            make.height.equalTo(15)
        }
        
        //邀请码
        let codeButton = UIButton.init()
        codeButton.setTitle("12345", for: .normal)
        codeButton.setTitleColor(UIColor.white, for: .normal)
        codeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
        codeButton.tag = 301
        codeButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        middleView.addSubview(codeButton)
        codeButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(middleView).offset(0)
            make.top.equalTo(latestLabel.snp_bottom).offset(15)
            make.height.equalTo(35)
        }
        
        //立即申请
        let applicationButton = UIButton.init()
        applicationButton.backgroundColor = UIColor.white
        applicationButton.layer.cornerRadius = 50 / 2.0
        applicationButton.clipsToBounds = true
        applicationButton.setTitle(LanguageHelper.getString(key: "Immediate application"), for: .normal)
        applicationButton.setTitleColor(UIColor.black, for: .normal)
        applicationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        applicationButton.tag = 302
        applicationButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        middleView.addSubview(applicationButton)
        applicationButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(middleView.snp_centerX)
            make.width.equalTo(150)
            make.top.equalTo(codeButton.snp_bottom).offset(25)
            make.height.equalTo(50)
        }
        
        //下半部
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = FYColor.mainColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.layer.cornerRadius = 5.0
        tableView.clipsToBounds = true
        tableView.register(FYApplicationCell.self, forCellReuseIdentifier: "cell")
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.top.equalTo(middleView.snp_bottom).offset(-10)
            make.height.equalTo(360)
        }
        
        return scrollView
    }()
    
    //申请成功
    lazy var successView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        
        //关闭按钮
        let closeButton = UIButton.init()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.tag = 400
        closeButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(20)
            make.top.equalTo(view).offset(15)
            make.height.equalTo(20)
        }
        
        //图片
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage(named: "apply_ok")
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(80)
            make.top.equalTo(view).offset(60)
            make.height.equalTo(80)
        }
        
        //提示
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "Application succeeded")
        tipLabel.textColor = UIColor.black
        tipLabel.font = UIFont.systemFont(ofSize: 25)
        tipLabel.textAlignment = .center
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).offset(0)
            make.top.equalTo(iconImageView.snp_bottom).offset(15)
            make.height.equalTo(25)
        }
        
        //返回查看
        let checkButton = UIButton.init()
        checkButton.backgroundColor = FYTool.hexStringToUIColor(hexString: "#F2F2F2")
        checkButton.layer.cornerRadius = 5.0
        checkButton.clipsToBounds = true
        checkButton.setTitle(LanguageHelper.getString(key: "Return to view"), for: .normal)
        checkButton.setTitleColor(UIColor.black, for: .normal)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        checkButton.tag = 401
        checkButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(150)
            make.bottom.equalTo(view).offset(-25)
            make.height.equalTo(45)
        }
        
        return view
    }()

}
