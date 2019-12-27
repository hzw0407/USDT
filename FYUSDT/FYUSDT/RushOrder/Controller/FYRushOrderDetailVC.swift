//
//  FYRushOrderDetailVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --抢单详情

import UIKit
import UICircularProgressRing
import HandyJSON

class FYRushOrderDetailVC: UIViewController,UITextFieldDelegate {
    
    //定时器
    var timer:Timer?
    var countTime:Int?
    //产品id
    var id:String?
    //详情模型
    var model:FYRushOrderDetailModel?
    //输入的投资金额
    var inputInt:Int = 0
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.creatUI()
        
        self.getDetailInfo(isShowAlertController: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
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
        
        self.view.addSubview(self.refreshButton)
        self.refreshButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.width.equalTo(22)
            make.top.equalTo(self.backButton.snp_top)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view).offset(0)
            make.top.equalTo(self.backButton.snp_bottom)
        }
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: 770 > FYScreenHeight ? 770 : FYScreenHeight)
        
        self.view.addSubview(self.successView)
        self.successView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(320)
        }
        
    }
    
    //获取详情
    func getDetailInfo(isShowAlertController:Bool) {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "id", value: self.id! as AnyObject)
        manager.request(type: .post, url: String(format: rushOrderDetail, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                self.model = JSONDeserializer<FYRushOrderDetailModel>.deserializeFrom(dict: dict["data"] as? NSDictionary)
                self.refreshInfo()
                if isShowAlertController {
                    let bottomView = self.scrollView.viewWithTag(300)!
                    let amountTextfield = bottomView.viewWithTag(304) as! UITextField
                    let alertController = UIAlertController.init(title: LanguageHelper.getString(key: "Insufficient balance"), message: String(format: LanguageHelper.getString(key: "Balancetip"), "\(self.model!.surplusAmount!)"), preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Cancel"), style: UIAlertAction.Style.cancel, handler: nil)
                    let confirmAction = UIAlertAction.init(title: LanguageHelper.getString(key: "Confirm"), style: UIAlertAction.Style.default) { (action) in
                        amountTextfield.text = String(format: "%.2f", (self.model?.surplusAmount! ?? "0"))
                        self.inputInt = Int((amountTextfield.text! as NSString).intValue)
                        self.placeOrder(productId: self.id!, amount: self.inputInt)
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //下单
    func placeOrder(productId:String,amount:Int) {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "productId", value: productId as AnyObject)
        manager.addparameter(key: "useAmount", value: "\(amount)" as AnyObject)
        manager.request(type: .post, url: String(format: PlaceOrder, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                NotificationCenter.default.post(name: NSNotification.Name.init("FYRushOrderDetailVC"), object: nil)
                self.successView.isHidden = false
                self.getDetailInfo(isShowAlertController: false)
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //刷新数据
    func refreshInfo() {
        let headerView = self.scrollView.viewWithTag(200)!
        let amountLable = headerView.viewWithTag(201) as! UILabel
        amountLable.text = String(format: "%.2f", self.model?.demandAmount ?? 0)
        
        let rateLabel = headerView.viewWithTag(202) as! UILabel
        let rateStr = NSMutableAttributedString(string: String(format: "%.1f%%", Double(self.model?.rewardRate ?? 0) * Double(100)))
        rateStr.addAttributes([NSAttributedString.Key.foregroundColor: FYColor.goldColor()], range: NSRange(location: 0, length: rateStr.length))
        rateStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: rateStr.length - 1))
        rateStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: rateStr.length - 1, length: 1))
        rateLabel.attributedText = rateStr
        
        let surplusLabel = headerView.viewWithTag(203) as! UILabel
        let surplusStr = NSMutableAttributedString(string: String(format: "%.2f", self.model?.surplusAmount ?? 0))
        surplusStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: surplusStr.length))
        surplusStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: surplusStr.length - 3))
        surplusStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: surplusStr.length - 3, length: 3))
        surplusLabel.attributedText = surplusStr
        
        let cirleView = headerView.viewWithTag(204) as! UICircularProgressRing
        cirleView.startProgress(to: CGFloat(((self.model?.surplusAmount ?? 0) / (self.model?.demandAmount ?? 0)) * Double(100)), duration: 0.1)
        
        let dayLabel = headerView.viewWithTag(205) as! UILabel
        dayLabel.text = String(format: LanguageHelper.getString(key: "Payment days"), self.model?.useNum ?? 0)
        
        self.countTime = self.model?.timeNum ?? 0
        if self.model?.timeNum ?? 0 > 0 {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
            }
        }
        
        let bottomView = self.scrollView.viewWithTag(300)!
        let balanceLabel = bottomView.viewWithTag(301) as! UILabel
        balanceLabel.text = String(format: "%.2f", self.model?.availableBalance ?? 0)
        
    }
    
    //倒计时
    @objc func countDown() {
        let headerView = self.scrollView.viewWithTag(200)!
        let timeLabel = headerView.viewWithTag(206) as! UILabel
        self.countTime! -= 1
        timeLabel.text = String(format: LanguageHelper.getString(key: "Remaining time"), FYTool.transToHourMinSec(time: Int(self.countTime!)))
        if self.countTime! <= 0 {
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
            let vc = FYRechargeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 303 {
            //输入全部余额
            let bottomView = self.scrollView.viewWithTag(300)!
            let amountTextfield = bottomView.viewWithTag(304) as! UITextField
            amountTextfield.text = String(format: "%.2f", (self.model?.availableBalance! ?? "0"))
            self.inputInt = Int((amountTextfield.text! as NSString).intValue)
        }else if btn.tag == 306 {
            //下单
            let bottomView = self.scrollView.viewWithTag(300)!
            let amountTextfield = bottomView.viewWithTag(304) as! UITextField
            amountTextfield.resignFirstResponder()
            if self.inputInt < 100 {
                //下单金额小于100
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Less100"))
            }else if self.inputInt % 100 != 0 {
                //下单金额不是100的整数
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "integer"))
            }else if self.inputInt > Int(self.model!.availableBalance!) {
                //下单金额大于可用余额
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Insufficient available balance"))
            }else if self.inputInt > Int(self.model!.surplusAmount!) {
                //下单金额大于剩余余额
                self.getDetailInfo(isShowAlertController: true)
            }else {
                self.placeOrder(productId: self.id!, amount: self.inputInt)
            }
        }else if btn.tag == 400 {
            //关闭成功提示
            self.successView.isHidden = true
        }else if btn.tag == 401 {
            //再抢一笔
            self.successView.isHidden = true
        }else if btn.tag == 402 {
            //查看订单
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 500 {
            //刷新
            self.getDetailInfo(isShowAlertController: false)
        }
    }

    //pragma mark - SystemDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 304 {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string) as NSString
            if newText.hasPrefix("0") {
                //不能以0开头
                textField.text = ""
                return false
            }else if newText.hasPrefix(".") {
                //不能以小数点开头
                textField.text = ""
                return false
            }else if string == "." {
                //不能包含小数点
                let tempstr = String(newText)
                textField.text = String(tempstr.prefix(range.location))
                return false
            }else if FYTool.checkInput(inputStr: string) == false {
                //不能包含除数字和小数点以外的字符
                let tempstr = String(newText)
                textField.text = String(tempstr.prefix(range.location))
                return false
            }
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 304 {
            self.inputInt = Int((textField.text! as NSString).intValue)
            let bottomView = self.scrollView.viewWithTag(300)!
            let profitLabel = bottomView.viewWithTag(305) as! YYLabel
            let profitStr = NSMutableAttributedString(string: String(format: LanguageHelper.getString(key: "Expected return"), String(format: "%.2f", Double(self.inputInt) * (self.model?.rewardRate ?? 0))))
            profitStr.yy_font = UIFont.systemFont(ofSize: 15)
            if FYTool.getLanguageType() == "en-CN" {
                profitStr.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 15))
                profitStr.yy_setColor(FYColor.goldColor(), range: NSRange(location: 15, length: profitStr.length - 15))
            }else {
                profitStr.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 4))
                profitStr.yy_setColor(FYColor.goldColor(), range: NSRange(location: 4, length: profitStr.length - 4))
            }
            profitLabel.attributedText = profitStr
        }
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
    
    //刷新按钮
    lazy var refreshButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.tag = 500
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
        
        //下半部
        let bottomView = UIView.init()
        bottomView.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        bottomView.tag = 300
        bottomView.layer.cornerRadius = 10.0
        bottomView.clipsToBounds = true
        scrollView.addSubview(bottomView)
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
        amountTextfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "placeOrderTip"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)])
        amountTextfield.font = UIFont.systemFont(ofSize: 12)
        amountTextfield.textColor = UIColor.white
        //设置右边扫描按钮
        let rightButton = UIButton(type: .custom)
        let rightWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "All"), font: UIFont.systemFont(ofSize: 13), height: 50)
        rightButton.frame = CGRect(x: 0, y: 0, width: rightWidth + 20, height: 50)
        rightButton.setTitle(LanguageHelper.getString(key: "All"), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightButton.tag = 303
        rightButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        amountTextfield.rightView = rightButton
        amountTextfield.rightViewMode = .always
        amountTextfield.keyboardType = UIKeyboardType.numberPad
        //设置光标初始位置
        amountTextfield.setValue(NSNumber.init(value: 14), forKey: "paddingLeft")
        amountTextfield.tag = 304
        amountTextfield.delegate = self
        bottomView.addSubview(amountTextfield)
        amountTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(balanceLabel.snp_left)
            make.right.equalTo(rechargeButton.snp_right)
            make.top.equalTo(balanceLabel.snp_bottom).offset(30)
            make.height.equalTo(50)
        }

        //预期收益
        let profitLabel = YYLabel.init()
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
    
    lazy var successView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.isHidden = true
        
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
        iconImageView.image = UIImage(named: "success_ok")
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(80)
            make.top.equalTo(view).offset(60)
            make.height.equalTo(80)
        }
        
        //提示
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "Congratulations")
        tipLabel.textColor = UIColor.black
        tipLabel.font = UIFont.systemFont(ofSize: 25)
        tipLabel.textAlignment = .center
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).offset(0)
            make.top.equalTo(iconImageView.snp_bottom).offset(15)
            make.height.equalTo(25)
        }
        
        //再抢一笔
        let againButton = UIButton.init()
        againButton.backgroundColor = FYColor.goldColor()
        againButton.layer.cornerRadius = 5.0
        againButton.clipsToBounds = true
        againButton.setTitle(LanguageHelper.getString(key: "Grab again"), for: .normal)
        againButton.setTitleColor(UIColor.white, for: .normal)
        againButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        againButton.tag = 401
        againButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(againButton)
        againButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.width.equalTo((FYScreenWidth - 75) / 2)
            make.bottom.equalTo(view).offset(-25)
            make.height.equalTo(45)
        }
        
        //查看订单
        let reviewButton = UIButton.init()
        reviewButton.backgroundColor = FYTool.hexStringToUIColor(hexString: "#F2F2F2")
        reviewButton.layer.cornerRadius = 5.0
        reviewButton.clipsToBounds = true
        reviewButton.setTitle(LanguageHelper.getString(key: "Review Order"), for: .normal)
        reviewButton.setTitleColor(UIColor.black, for: .normal)
        reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        reviewButton.tag = 402
        reviewButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(reviewButton)
        reviewButton.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-30)
            make.width.equalTo(againButton.snp_width)
            make.bottom.equalTo(againButton.snp_bottom)
            make.height.equalTo(againButton.snp_height)
        }
        
        return view
    }()

}
