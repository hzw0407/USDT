//
//  FYWithdrawVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --提币

import UIKit
import HandyJSON

class FYWithdrawVC: UIViewController,GQScanViewControllerDelegate,UITextFieldDelegate {
    
    //1收益提币 2本金提币
    var type:Int?
    //数据模型
    var model:FYWithdrawModel?
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view).offset(0)
        }
        
        self.scrollView.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.scrollView).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.height.equalTo(200)
        }
        self.scrollView.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView).offset(0)
            make.width.equalTo(self.headerView.snp_width)
            make.top.equalTo(self.headerView.snp_bottom)
            make.height.equalTo(FYScreenHeight - 200)
        }
        
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: FYScreenHeight)
        
        self.getInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    //获取提币相关信息
    func getInfo() {
        let typeStr = self.type == 1 ? "5" : "2"
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "type", value: typeStr as AnyObject)
        manager.request(type: .post, url: String(format: withdrawInfo, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                self.model = JSONDeserializer<FYWithdrawModel>.deserializeFrom(dict: dict["data"] as? NSDictionary)
            }else {
                MBProgressHUD.showInfo(message)
            }
            self.refreshInfo()
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //提币申请
    func application() {
        let typeStr = self.type == 1 ? "5" : "2"
        let addressTextfield = self.bottomView.viewWithTag(201) as! UITextField
        let withdrawTextfield = self.bottomView.viewWithTag(202) as! UITextField
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.addparameter(key: "type", value: typeStr as AnyObject)
        manager.addparameter(key: "amount", value: "\(Double((withdrawTextfield.text! as NSString).doubleValue) - (self.model?.withdrawFee ?? 0))" as AnyObject)
        manager.addparameter(key: "fee", value: "\(self.model?.withdrawFee ?? 0)" as AnyObject)
        manager.addparameter(key: "desAddress", value: addressTextfield.text! as AnyObject)
        manager.request(type: .post, url: String(format: withdrawApplication, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Successful application"))
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //刷新数据
    func refreshInfo() {
        let numberLabel = self.bottomView.viewWithTag(200) as! UILabel
        numberLabel.text = String(format: "%.f USDT", self.model?.availableAmount ?? 0)
        let withdrawTextfield = self.bottomView.viewWithTag(202) as! UITextField
        withdrawTextfield.attributedPlaceholder = NSAttributedString.init(string: String(format: LanguageHelper.getString(key: "Withdraw Placeholder"), self.model?.availableAmount ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)])
        let feeLabel = self.bottomView.viewWithTag(203) as! YYLabel
        let str = NSMutableAttributedString(string: String(format: LanguageHelper.getString(key: "Miner cost"), self.model?.withdrawFee ?? 0))
        str.yy_font = UIFont.systemFont(ofSize: 12)
        if FYTool.getLanguageType() == "en-CN" {
            str.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 10))
            str.yy_setColor(FYColor.goldColor(), range: NSRange(location: 10, length: str.length - 10))
        }else {
            str.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 4))
            str.yy_setColor(FYColor.goldColor(), range: NSRange(location: 4, length: str.length - 4))
        }
        feeLabel.attributedText = str
        feeLabel.textAlignment = .right
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 101 {
            //记录
            let vc = FYBillVC()
            vc.selectType = self.type == 1 ? 5 : 2
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 204 {
            //确认提币
            let addressTextfield = self.bottomView.viewWithTag(201) as! UITextField
            let withdrawTextfield = self.bottomView.viewWithTag(202) as! UITextField
            if addressTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Emputy WithdrawalAddress"))
            }else if withdrawTextfield.text!.count <= 0 {
                MBProgressHUD.showInfo(LanguageHelper.getString(key: "Emputy WithdrawingAmount"))
            }else if Double((withdrawTextfield.text! as NSString).doubleValue) < self.model?.startAmount ?? 0 {
                MBProgressHUD.showInfo(String(format: LanguageHelper.getString(key: "The starting amount is"), self.model?.startAmount ?? 0))
            }else {
                self.application()
            }
        }
    }
    
    //点击扫描按钮
    @objc func scanClick() {
        let vc = GQScanViewController(scan: nil);
        vc.delegate = self as GQScanViewControllerDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击全部提币
    @objc func allClick() {
        let withdrawTextfield = self.bottomView.viewWithTag(202) as! UITextField
        withdrawTextfield.text = "\(self.model?.availableAmount ?? 0)"
    }

    //pragma mark - SystemDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 202 {
            if Double((textField.text! as NSString).doubleValue) < self.model?.startAmount ?? 0 {
                MBProgressHUD.showInfo(String(format: LanguageHelper.getString(key: "The starting amount is"), self.model?.startAmount ?? 0))
                textField.text = ""
            }
        }
    }

    //pragma mark - CustomDelegate
    //扫描到的数据
    func scanResult(result:String) {
        let addressTextfield = self.bottomView.viewWithTag(201) as! FYUITextField
        addressTextfield.text = result
    }

    //pragma mark - GetterAndSetter
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var headerView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.mainColor()
        //返回按钮
        let backButton = UIButton.init()
        backButton.setImage(UIImage(named: "arrow_left"), for: .normal)
        backButton.tag = 100
        backButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(28.5)
            make.top.equalTo(view).offset(35)
            make.height.equalTo(20)
        }
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "Withdraw1")
        titleLabel.textColor = FYColor.goldColor()
        titleLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp_left)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(backButton.snp_bottom).offset(30)
            make.height.equalTo(35)
        }
        
        //说明
        let explainLabel = UILabel.init()
        if self.type == 1 {
            explainLabel.text = LanguageHelper.getString(key: "Profit Explain")
        }else {
            explainLabel.text = LanguageHelper.getString(key: "Principal Explain")
        }
        explainLabel.textColor = UIColor.gray
        explainLabel.font = UIFont.systemFont(ofSize: 13)
        explainLabel.numberOfLines = 0
        view.addSubview(explainLabel)
        explainLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.height.equalTo(50)
        }
        
        //记录
        let recordButton = UIButton.init()
        recordButton.setTitle(LanguageHelper.getString(key: "Record"), for: .normal)
        recordButton.setTitleColor(FYColor.goldColor(), for: .normal)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        recordButton.tag = 101
        recordButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(recordButton)
        let recordButtonWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Record"), font: UIFont.systemFont(ofSize: 13), height: 30)
        recordButton.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-15)
            make.width.equalTo(recordButtonWidth + 5)
            make.centerY.equalTo(view.snp_centerY)
            make.height.equalTo(30)
        }
        return view
    }()
    
    lazy var bottomView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
        //可提币数量标题
        let numberTitleLabel = UILabel.init()
        numberTitleLabel.text = LanguageHelper.getString(key: "Amount of withdrawable currency")
        numberTitleLabel.textColor = UIColor.gray
        numberTitleLabel.font = UIFont.systemFont(ofSize: 14)
        numberTitleLabel.textAlignment = .center
        view.addSubview(numberTitleLabel)
        numberTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.top.equalTo(view).offset(60)
            make.height.equalTo(15)
        }
        
        //可提币数量
        let numberLabel = UILabel.init()
        numberLabel.textColor = FYColor.goldColor()
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.textAlignment = .center
        numberLabel.tag = 200
        view.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numberTitleLabel.snp_left)
            make.width.equalTo(numberTitleLabel.snp_width)
            make.top.equalTo(numberTitleLabel.snp_bottom).offset(10)
            make.height.equalTo(numberTitleLabel.snp_height)
        }
        
        //提币地址
        let addressLabel = UILabel.init()
        addressLabel.text = LanguageHelper.getString(key: "Money withdrawal address")
        addressLabel.textColor = UIColor.black
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(45)
            make.width.equalTo(FYScreenWidth - 90)
            make.top.equalTo(numberLabel.snp_bottom).offset(30)
            make.height.equalTo(15)
        }
        
        let addressTextfield = FYUITextField.init()
        addressTextfield.backgroundColor = FYColor.rgb(243, 244, 249, 1.0)
        addressTextfield.layer.borderWidth = 1.0
        addressTextfield.layer.borderColor = FYTool.hexStringToUIColor(hexString: "#E2E2E2").cgColor
        addressTextfield.attributedPlaceholder = NSAttributedString.init(string: LanguageHelper.getString(key: "USDT withdrawal address"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)])
        addressTextfield.font = UIFont.systemFont(ofSize: 15)
        //设置右边扫描按钮
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "code"), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        addressTextfield.rightView = rightButton
        addressTextfield.rightViewMode = .always
        //设置光标初始位置
        addressTextfield.setValue(NSNumber.init(value: 14), forKey: "paddingLeft")
        addressTextfield.tag = 201
        view.addSubview(addressTextfield)
        addressTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp_left)
            make.width.equalTo(addressLabel.snp_width)
            make.top.equalTo(addressLabel.snp_bottom).offset(10)
            make.height.equalTo(45)
        }
        
        //提币数量
        let withdrawTitleLabel = UILabel.init()
        withdrawTitleLabel.text = LanguageHelper.getString(key: "Amount of money raised")
        withdrawTitleLabel.textColor = UIColor.black
        withdrawTitleLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(withdrawTitleLabel)
        withdrawTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp_left)
            make.width.equalTo(addressLabel.snp_width)
            make.top.equalTo(addressTextfield.snp_bottom).offset(20)
            make.height.equalTo(addressLabel.snp_height)
        }
        
        let withdrawTextfield = FYUITextField.init()
        withdrawTextfield.backgroundColor = FYColor.rgb(243, 244, 249, 1.0)
        withdrawTextfield.layer.borderWidth = 1.0
        withdrawTextfield.layer.borderColor = FYTool.hexStringToUIColor(hexString: "#E2E2E2").cgColor
        withdrawTextfield.font = UIFont.systemFont(ofSize: 15)
        //设置右边全部按钮
        let rightButtonWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "All"), font: UIFont.systemFont(ofSize: 12), height: 20)
        let withdrawRightButton = UIButton(type: .custom)
        withdrawRightButton.setTitle(LanguageHelper.getString(key: "All"), for: .normal)
        withdrawRightButton.setTitleColor(FYColor.goldColor(), for: .normal)
        withdrawRightButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        withdrawRightButton.frame = CGRect(x: 0, y: 0, width: rightButtonWidth + 5, height: 20)
        withdrawRightButton.addTarget(self, action: #selector(allClick), for: .touchUpInside)
        withdrawTextfield.rightView = withdrawRightButton
        withdrawTextfield.rightViewMode = .always
        //设置光标初始位置
        withdrawTextfield.setValue(NSNumber.init(value: 14), forKey: "paddingLeft")
        withdrawTextfield.tag = 202
        withdrawTextfield.delegate = self
        view.addSubview(withdrawTextfield)
        withdrawTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(addressTextfield.snp_left)
            make.width.equalTo(addressTextfield.snp_width)
            make.top.equalTo(withdrawTitleLabel.snp_bottom).offset(10)
            make.height.equalTo(addressTextfield.snp_height)
        }
        
        //旷工费用
        let feeLabel = YYLabel.init()
        feeLabel.tag = 203
        view.addSubview(feeLabel)
        feeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(withdrawTextfield.snp_left)
            make.right.equalTo(withdrawTextfield.snp_right)
            make.top.equalTo(withdrawTextfield.snp_bottom).offset(10)
            make.height.equalTo(15)
        }
        
        //确认提币
        let confirmButton = UIButton.init()
        confirmButton.backgroundColor = FYColor.goldColor()
        confirmButton.layer.cornerRadius = 50 / 2.0
        confirmButton.clipsToBounds = true
        confirmButton.setTitle(LanguageHelper.getString(key: "Confirmation of withdrawals"), for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmButton.tag = 204
        confirmButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(withdrawTextfield.snp_left)
            make.right.equalTo(withdrawTextfield.snp_right)
            make.top.equalTo(feeLabel.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        
        //提示
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "WithdrawTip")
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.numberOfLines = 0
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(confirmButton.snp_left)
            make.right.equalTo(confirmButton.snp_right)
            make.top.equalTo(confirmButton.snp_bottom).offset(5)
            make.height.equalTo(70)
        }
        
        return view
    }()

}
