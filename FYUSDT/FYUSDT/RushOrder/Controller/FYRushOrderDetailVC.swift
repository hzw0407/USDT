//
//  FYRushOrderDetailVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --抢单详情

import UIKit
import UICircularProgressRing

class FYRushOrderDetailVC: UIViewController {
    
    //定时器
    var timer:Timer?
    var countTime = arc4random() % 1000
    
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
            make.left.right.bottom.equalTo(self.view).offset(0)
            make.top.equalTo(self.backButton.snp_bottom)
        }
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: 770 > FYScreenHeight ? 770 : FYScreenHeight)
        
    }
    
    @objc func countDown() {
        let headerView = self.scrollView.viewWithTag(200)!
        let timeLabel = headerView.viewWithTag(206) as! UILabel
        self.countTime -= 1
        timeLabel.text = String(format: LanguageHelper.getString(key: "Remaining time"), FYTool.transToHourMinSec(time: Int(self.countTime)))
        if self.countTime <= 0 {
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 302 {
            //充币
        }else if btn.tag == 303 {
            //输入全部余额
        }else if btn.tag == 306 {
            //下单
        }
    }

    //pragma mark - SystemDelegate

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
        let headerView = UIView.init()
        headerView.backgroundColor = FYColor.mainColor()
        headerView.tag = 200
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.top.equalTo(scrollView).offset(0)
            make.height.equalTo(330)
        }
        
        //标题
        let titleLbale = UILabel.init()
        titleLbale.text = LanguageHelper.getString(key: "Grab details")
        titleLbale.textColor = FYColor.goldColor()
        titleLbale.font = UIFont.systemFont(ofSize: 35)
        headerView.addSubview(titleLbale)
        titleLbale.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(15)
            make.right.equalTo(headerView).offset(-15)
            make.top.equalTo(headerView).offset(30)
            make.height.equalTo(35)
        }
        
        //需求金额标题
        let amountTitleLabel = UILabel.init()
        amountTitleLabel.text = LanguageHelper.getString(key: "Demand amount")
        amountTitleLabel.textColor = UIColor.gray
        amountTitleLabel.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbale.snp_left)
            make.width.equalTo(titleLbale.snp_width)
            make.top.equalTo(titleLbale.snp_bottom).offset(50)
            make.height.equalTo(15)
        }
        
        //需求金额
        let amountLable = UILabel.init()
        amountLable.text = "10000.00"
        amountLable.textColor = UIColor.white
        amountLable.font = UIFont.boldSystemFont(ofSize: 45)
        amountLable.tag = 201
        headerView.addSubview(amountLable)
        amountLable.snp.makeConstraints { (make) in
            make.left.equalTo(amountTitleLabel.snp_left)
            make.width.equalTo(amountTitleLabel.snp_width)
            make.top.equalTo(amountTitleLabel.snp_bottom).offset(15)
            make.height.equalTo(35)
        }
        
        //预计年利化率标题
        let rateTitleLabel = UILabel.init()
        rateTitleLabel.text = LanguageHelper.getString(key: "Annual interest rate")
        rateTitleLabel.textColor = UIColor.gray
        rateTitleLabel.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(rateTitleLabel)
        rateTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(amountLable.snp_left)
            make.width.equalTo((FYScreenWidth - 80) / 2)
            make.top.equalTo(amountLable.snp_bottom).offset(30)
            make.height.equalTo(15)
        }
        
        //预计年利化率
        let rateLabel = UILabel.init()
        let str = NSMutableAttributedString(string: "6.0%")
        str.addAttributes([NSAttributedString.Key.foregroundColor: FYColor.goldColor()], range: NSRange(location: 0, length: str.length))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: str.length - 1))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: str.length - 1, length: 1))
        rateLabel.attributedText = str
        rateLabel.tag = 202
        headerView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rateTitleLabel.snp_left)
            make.width.equalTo(rateTitleLabel.snp_width)
            make.top.equalTo(rateTitleLabel.snp_bottom).offset(10)
            make.height.equalTo(20)
        }
        
        //剩余额度标题
        let surplusTitleLabel = UILabel.init()
        surplusTitleLabel.text = LanguageHelper.getString(key: "Surplus amount")
        surplusTitleLabel.textColor = UIColor.gray
        surplusTitleLabel.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(surplusTitleLabel)
        surplusTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rateTitleLabel.snp_right)
            make.width.equalTo(rateTitleLabel.snp_width)
            make.top.equalTo(rateTitleLabel.snp_top)
            make.height.equalTo(rateTitleLabel.snp_height)
        }
        
        //剩余额度
        let surplusLabel = UILabel.init()
        let str1 = NSMutableAttributedString(string: "10000.00")
        str1.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: str1.length))
        str1.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: str1.length - 3))
        str1.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: str1.length - 3, length: 3))
        surplusLabel.attributedText = str1
        surplusLabel.tag = 203
        headerView.addSubview(surplusLabel)
        surplusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(surplusTitleLabel.snp_left)
            make.width.equalTo(surplusTitleLabel.snp_width)
            make.top.equalTo(rateLabel.snp_top)
            make.height.equalTo(rateLabel.snp_height)
        }
        
        //进度圈
        let cirleView = UICircularProgressRing.init()
        cirleView.style = .ontop
        //最大值
        cirleView.maxValue = 100.0
        //进度值颜色
        cirleView.fontColor = FYColor.goldColor()
        //进度值大小
        cirleView.font = UIFont.systemFont(ofSize: 10)
        //外环
        cirleView.outerRingWidth = 5.0
        //剩余的进度颜色
        cirleView.outerRingColor = UIColor.gray
        //进度条颜色
        cirleView.innerRingColor = FYColor.goldColor()
        //设置进度
        cirleView.startProgress(to: 30, duration: 0.1)
        cirleView.tag = 204
        headerView.addSubview(cirleView)
        cirleView.snp.makeConstraints { (make) in
            make.right.equalTo(headerView).offset(-15)
            make.width.equalTo(35)
            make.top.equalTo(surplusTitleLabel.snp_top)
            make.height.equalTo(35)
        }
        
        //用款天数
        let dayLabel = UILabel.init()
        dayLabel.text = String(format: LanguageHelper.getString(key: "Payment days"), 1)
        dayLabel.textColor = UIColor.gray
        dayLabel.font = UIFont.systemFont(ofSize: 13)
        dayLabel.tag = 205
        headerView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rateLabel.snp_left)
            make.width.equalTo(rateLabel.snp_width)
            make.top.equalTo(rateLabel.snp_bottom).offset(30)
            make.height.equalTo(15)
        }
        
        //剩余时间
        let timeLabel = UILabel.init()
        timeLabel.textColor = UIColor.gray
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.tag = 206
        headerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(surplusLabel.snp_left)
            make.right.equalTo(headerView).offset(0)
            make.top.equalTo(dayLabel.snp_top)
            make.height.equalTo(dayLabel.snp_height)
        }
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
        
        //下半部
        let bottomView = UIView.init()
        bottomView.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        bottomView.tag = 300
        bottomView.layer.cornerRadius = 10.0
        bottomView.clipsToBounds = true
        headerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp_left)
            make.width.equalTo(headerView.snp_width)
            make.top.equalTo(headerView.snp_bottom)
            make.height.equalTo(420)
        }
        
        //可用余额标题
        let balanceTitleLabel = UILabel.init()
        balanceTitleLabel.text = LanguageHelper.getString(key: "Available balance")
        balanceTitleLabel.textColor = UIColor.gray
        balanceTitleLabel.font = UIFont.systemFont(ofSize: 13)
        bottomView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(30)
            make.width.equalTo(200)
            make.top.equalTo(bottomView).offset(50)
            make.height.equalTo(15)
        }

        //可用余额
        let balanceLabel = UILabel.init()
        balanceLabel.text = "10000.00"
        balanceLabel.textColor = UIColor.white
        balanceLabel.font = UIFont.systemFont(ofSize: 25)
        balanceLabel.tag = 301
        bottomView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(balanceTitleLabel.snp_left)
            make.width.equalTo(balanceTitleLabel.snp_width)
            make.top.equalTo(balanceTitleLabel.snp_bottom).offset(10)
            make.height.equalTo(20)
        }

        //充币按钮
        let rechargeButton = UIButton.init()
        rechargeButton.backgroundColor = FYColor.goldColor()
        rechargeButton.layer.cornerRadius = 45 / 2.0
        rechargeButton.clipsToBounds = true
        rechargeButton.setTitle(LanguageHelper.getString(key: "Coin charging"), for: .normal)
        rechargeButton.setTitleColor(UIColor.white, for: .normal)
        rechargeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rechargeButton.tag = 302
        rechargeButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        bottomView.addSubview(rechargeButton)
        rechargeButton.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView).offset(-30)
            make.width.equalTo(100)
            make.top.equalTo(balanceTitleLabel.snp_top)
            make.height.equalTo(45)
        }

        //下单金额输入框
        let amountTextfield = FYUITextField.init()
        amountTextfield.backgroundColor = FYColor.rgb(32, 32, 32, 1.0)
        amountTextfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "Please enter the order amount"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)])
        amountTextfield.font = UIFont.systemFont(ofSize: 15)
        //设置右边扫描按钮
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle(LanguageHelper.getString(key: "All"), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightButton.tag = 303
        rightButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        amountTextfield.rightView = rightButton
        amountTextfield.rightViewMode = .always
        //设置光标初始位置
        amountTextfield.setValue(NSNumber.init(value: 14), forKey: "paddingLeft")
        amountTextfield.tag = 304
        bottomView.addSubview(amountTextfield)
        amountTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(balanceLabel.snp_left)
            make.right.equalTo(rechargeButton.snp_right)
            make.top.equalTo(balanceLabel.snp_bottom).offset(30)
            make.height.equalTo(50)
        }

        //预期收益
        let profitLabel = YYLabel.init()
        let str2 = NSMutableAttributedString(string: String(format: LanguageHelper.getString(key: "Expected return"), "12345"))
        str2.yy_font = UIFont.systemFont(ofSize: 15)
        if FYTool.getLanguageType() == "en-CN" {
            str2.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 15))
            str2.yy_setColor(FYColor.goldColor(), range: NSRange(location: 15, length: str2.length - 15))
        }else {
            str2.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 4))
            str2.yy_setColor(FYColor.goldColor(), range: NSRange(location: 4, length: str2.length - 4))
        }
        profitLabel.attributedText = str2
        profitLabel.tag = 305
        bottomView.addSubview(profitLabel)
        profitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(amountTextfield.snp_left)
            make.width.equalTo(amountTextfield.snp_width)
            make.top.equalTo(amountTextfield.snp_bottom).offset(15)
            make.height.equalTo(15)
        }
        
        //立即下单
        let placeOrderButton = UIButton.init()
        placeOrderButton.backgroundColor = FYColor.goldColor()
        placeOrderButton.layer.cornerRadius = 50 / 2.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.setTitle(LanguageHelper.getString(key: "Place an order"), for: .normal)
        placeOrderButton.setTitleColor(UIColor.white, for: .normal)
        placeOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        placeOrderButton.tag = 306
        placeOrderButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        bottomView.addSubview(placeOrderButton)
        placeOrderButton.snp.makeConstraints { (make) in
            make.left.equalTo(profitLabel.snp_left)
            make.width.equalTo(profitLabel.snp_width)
            make.top.equalTo(profitLabel.snp_bottom).offset(50)
            make.height.equalTo(50)
        }
        
        return scrollView
    }()

}
