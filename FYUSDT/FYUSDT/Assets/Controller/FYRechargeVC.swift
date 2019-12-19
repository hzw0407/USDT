//
//  FYRechargeVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --充币

import UIKit
import EFQRCode

class FYRechargeVC: UIViewController {
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view).offset(0)
            make.height.equalTo(200)
        }
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.headerView.snp_bottom)
            make.bottom.equalTo(self.view).offset(0)
        }
        self.bottomView.contentSize = CGSize(width: FYScreenWidth, height: 500 > FYScreenHeight - 200 ? 500 : FYScreenHeight - 200)
        
        self.view.addSubview(self.USDTImageView)
        self.USDTImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(0)
            make.width.equalTo(50)
            make.top.equalTo(self.bottomView.snp_top).offset(-25)
            make.height.equalTo(50)
        }
        
        self.getRechargeAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod
    //获取用户充值地址
    func getRechargeAddress() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.request(type: .post, url: String(format: getAddress, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                let codeAddressView = self.bottomView.viewWithTag(201)!
                let codeAddressLabel = codeAddressView.viewWithTag(202) as! UILabel
                let codeImageView = self.bottomView.viewWithTag(203) as! UIImageView
                let address = dict["data"] as? NSString
                if address != nil {
                    codeAddressLabel.text = address! as String
                    if let tryImage = EFQRCode.generate(
                        content: address! as String
                        ) {
                        codeImageView.image = UIImage.init(cgImage: tryImage)
                    }
                }
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMesaage) in
            MBProgressHUD.showInfo(errMesaage)
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
           if error != nil{
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "Save failed"))
           }else{
            MBProgressHUD.showInfo(LanguageHelper.getString(key: "Save successfully"))
           }
       }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            self.navigationController?.popViewController(animated: true)
        }else if btn.tag == 101 {
            //记录
            let vc = FYBillVC()
            vc.selectType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 200 {
            //保存图片
            let codeImageView = self.bottomView.viewWithTag(203) as! UIImageView
            UIImageWriteToSavedPhotosAlbum(codeImageView.image!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //复制二维码
    @objc func tapClick() {
        let codeAddressView = self.bottomView.viewWithTag(201)!
        let addressLabel = codeAddressView.viewWithTag(202) as! UILabel
        UIPasteboard.general.string = addressLabel.text
        MBProgressHUD.showInfo(LanguageHelper.getString(key: "copy_success"))
    }

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
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
            make.top.equalTo(view).offset(55)
            make.height.equalTo(20)
        }
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = LanguageHelper.getString(key: "Recharge1")
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
        tipLabel.text = LanguageHelper.getString(key: "RechargeTip")
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.height.equalTo(15)
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
    
    lazy var bottomView:UIScrollView = {
        let view = UIScrollView.init()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
        //二维码图片
        let codeImageView = UIImageView.init()
//        codeImageView.image = UIImage(named: "1576311370176")
        codeImageView.tag = 203
        view.addSubview(codeImageView)
        codeImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(106)
            make.top.equalTo(view).offset(70)
            make.height.equalTo(106)
        }

        //保存到相册
        let saveButton = UIButton.init()
        saveButton.setTitle(LanguageHelper.getString(key: "Save"), for: .normal)
        saveButton.setTitleColor(FYColor.greenColor(), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        saveButton.tag = 200
        saveButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(saveButton)
        let saveWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Save"), font: UIFont.systemFont(ofSize: 13), height: 20)
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(saveWidth + 10)
            make.top.equalTo(codeImageView.snp_bottom).offset(20)
            make.height.equalTo(20)
        }

        //钱包地址
        let addressLabel = UILabel.init()
        addressLabel.text = LanguageHelper.getString(key: "Address")
        addressLabel.textColor = UIColor.gray
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.textAlignment = .center
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.width.equalTo(FYScreenWidth)
            make.top.equalTo(saveButton.snp_bottom).offset(50)
            make.height.equalTo(15)
        }
        
        //二维码地址
        let codeAddressView = UIView.init()
        codeAddressView.backgroundColor = FYTool.hexStringToUIColor(hexString: "#F2F2F2")
        codeAddressView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        codeAddressView.addGestureRecognizer(tap)
        codeAddressView.tag = 201
        view.addSubview(codeAddressView)
        codeAddressView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(FYScreenWidth - 30)
            make.top.equalTo(addressLabel.snp_bottom).offset(10)
            make.height.equalTo(40)
        }
        
        let codeAddressLabel = UILabel.init()
        codeAddressLabel.textColor = UIColor.black
        codeAddressLabel.font = UIFont.systemFont(ofSize: 15)
        codeAddressLabel.numberOfLines = 0
        codeAddressLabel.tag = 202
        codeAddressView.addSubview(codeAddressLabel)
        codeAddressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(codeAddressView).offset(40)
            make.right.equalTo(codeAddressView).offset(-40)
            make.centerY.equalTo(codeAddressView.snp_centerY)
            make.height.equalTo(codeAddressView.snp_height)
        }
        
        //复制按钮
        let copyImageView = UIImageView.init()
        copyImageView.image = UIImage(named: "copy")
        codeAddressView.addSubview(copyImageView)
        copyImageView.snp.makeConstraints { (make) in
            make.right.equalTo(codeAddressView).offset(-10)
            make.width.equalTo(20)
            make.centerY.equalTo(codeAddressView.snp_centerY)
            make.height.equalTo(20)
        }
        
        //温馨提示
        let tipLabel = UILabel.init()
        tipLabel.text = LanguageHelper.getString(key: "Recharge Tip")
        tipLabel.textColor = UIColor.black
        tipLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(FYScreenWidth - 30)
            make.top.equalTo(codeAddressView.snp_bottom).offset(60)
            make.height.equalTo(17)
        }
        
        //提示详情
        let tipDetailLabel = UILabel.init()
        tipDetailLabel.text = LanguageHelper.getString(key: "Tip Detail")
        tipDetailLabel.textColor = UIColor.gray
        tipDetailLabel.font = UIFont.systemFont(ofSize: 13)
        tipDetailLabel.numberOfLines = 0
        view.addSubview(tipDetailLabel)
        tipDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp_left)
            make.right.equalTo(tipLabel.snp_right)
            make.top.equalTo(tipLabel.snp_bottom).offset(10)
            make.bottom.equalTo(view).offset(0)
        }
        return view
    }()
    
    lazy var USDTImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "usdt")
        return imageView
    }()

}
