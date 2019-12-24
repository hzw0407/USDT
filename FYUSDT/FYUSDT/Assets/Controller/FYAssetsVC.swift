//
//  FYAssetsVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/12.
//  Copyright © 2019 何志武. All rights reserved.
//  --资产

import UIKit
import HandyJSON

class FYAssetsVC: UIViewController {
    
    //跑马灯
    let hourseView = JJMarqueeView.init(frame: CGRect.init(x: 0, y: (navigationHeight + 35 + 20 + 152 + 40 + 115 + 70 + 70 + 10), width: FYScreenWidth, height: 20))
    //资产模型
    var assetsModel:FYAssetsModel?
    //消息数组
    var infoArray:[FYInfoModel]?
    //下拉刷新
    let header = MJRefreshNormalHeader()
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FYColor.mainColor()
        self.creatUI()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle(LanguageHelper.getString(key: "headRefresh1"), for: .idle)
        header.setTitle(LanguageHelper.getString(key: "headRefresh2"), for: .pulling)
        header.setTitle(LanguageHelper.getString(key: "headRefresh3"), for: .refreshing)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.scrollView.mj_header = header
        header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.hourseView.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hourseView.cancelTimer()
    }

    //pragma mark - CustomMethod
    func creatUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(-bottomSafeAreaHeight)
        }
        
        self.scrollView.addSubview(self.titleLabel)
        let titleWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Assets"), font: UIFont.systemFont(ofSize: 35), height: 35)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(titleWidth + 5)
            make.top.equalTo(self.scrollView).offset(navigationHeight)
            make.height.equalTo(35)
        }
        
        let detailWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Asset details"), font: UIFont.systemFont(ofSize: 13), height: 13)
        self.scrollView.addSubview(self.detailButton)
        self.detailButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.width.equalTo(detailWidth + 5)
            make.bottom.equalTo(self.titleLabel.snp_bottom)
            make.height.equalTo(13)
        }
        
        self.scrollView.addSubview(self.totalImageView)
        self.totalImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(20)
            make.height.equalTo(152)
        }
        
        self.scrollView.addSubview(self.operationView)
        self.operationView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.totalImageView.snp_bottom).offset(40)
            make.height.equalTo(115)
        }
        
        self.scrollView.addSubview(self.rushOrderButton)
        self.rushOrderButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.operationView.snp_bottom).offset(70)
            make.height.equalTo(70)
        }
        self.rushOrderButton.layoutIfNeeded()
        self.rushOrderButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.hourseView.automaticSlidingInterval = 2
        self.hourseView.delegate = self
        self.hourseView.dataSource = self
        self.scrollView.addSubview(self.hourseView)
        self.scrollView.contentSize = CGSize(width: FYScreenWidth, height: (navigationHeight + 35 + 20 + 152 + 40 + 115 + 70 + 70 + 10) > FYScreenHeight ? (navigationHeight + 35 + 20 + 152 + 40 + 115 + 70 + 70 + 10) : FYScreenHeight)
    }
    
    //下拉刷新
    @objc func headerRefresh() {
        self.getAssets()
        self.infoList()
    }
    
    //获取资产
    func getAssets() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.request(type: .post, url: String(format: Wallet_Assets, UserDefaults.standard.string(forKey: FYToken)!), successCompletion: { (dict, message) in
            self.scrollView.mj_header?.endRefreshing()
            if dict["code"]?.intValue == 200 {
                self.assetsModel = JSONDeserializer<FYAssetsModel>.deserializeFrom(dict: dict["data"] as? NSDictionary)
                self.refreshInfo()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            self.scrollView.mj_header?.endRefreshing()
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //获取滚动信息
    func infoList() {
        let manager = FYRequestManager.shared
        manager.clearparameter()
        manager.request(type: .post, url: Assets_InfoList, successCompletion: { (dict, message) in
            if dict["code"]?.intValue == 200 {
                self.infoArray = JSONDeserializer<FYInfoModel>.deserializeModelArrayFrom(array: dict["data"] as? NSArray) as? [FYInfoModel]
                self.hourseView.reload()
            }else {
                MBProgressHUD.showInfo(message)
            }
        }) { (errMessage) in
            MBProgressHUD.showInfo(errMessage)
        }
    }
    
    //刷新数据
    func refreshInfo() {
        let totalAssetLabel = self.totalImageView.viewWithTag(200) as! UILabel
        totalAssetLabel.text = String(format: "%.f", self.assetsModel?.balance ?? 0)
        let profitLabel = self.totalImageView.viewWithTag(201) as! UILabel
        profitLabel.text = String(format: LanguageHelper.getString(key: "Accumulated income"), self.assetsModel?.getBalance ?? 0)
    }

    //pragma mark - ClickMethod
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 100 {
            //资产明细
            let vc = FYBillVC()
            vc.selectType = 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 400 {
            //立即抢单
            let tabbarVC = FYTabbarVC()
            tabbarVC.selectedIndex = 1
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            AppDelegate.window?.rootViewController = tabbarVC
        }
    }
    
    @objc func tapClick(tap:UITapGestureRecognizer) {
        if tap.view!.tag == 300 {
            //提币
            let vc = FYWithdrawVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tap.view!.tag == 301 {
            //充币
            let vc = FYRechargeVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tap.view!.tag == 400 {
            //立即抢单
            let tabbarVC = FYTabbarVC()
            tabbarVC.selectedIndex = 1
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            AppDelegate.window?.rootViewController = tabbarVC
        }
    }

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = FYColor.mainColor()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //资产标题
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Assets")
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    //资产明细
    lazy var detailButton:UIButton = {
        let button = UIButton.init()
        button.setTitle(LanguageHelper.getString(key: "Asset details"), for: .normal)
        button.setTitleColor(FYColor.goldColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //总资产
    lazy var totalImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "Aseet_Total")
        
        //总资产标题
        let totalAssetTitleLabel = UILabel.init()
        totalAssetTitleLabel.text = LanguageHelper.getString(key: "Total Assets")
        totalAssetTitleLabel.textColor = UIColor.white
        totalAssetTitleLabel.font = UIFont.systemFont(ofSize: 13)
        totalAssetTitleLabel.textAlignment = .center
        imageView.addSubview(totalAssetTitleLabel)
        totalAssetTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(imageView).offset(0)
            make.top.equalTo(25)
            make.height.equalTo(13)
        }
        
        //总资产
        let totalAssetLabel = UILabel.init()
        totalAssetLabel.textColor = UIColor.white
        totalAssetLabel.font = UIFont.boldSystemFont(ofSize: 45)
        totalAssetLabel.textAlignment = .center
        totalAssetLabel.tag = 200
        imageView.addSubview(totalAssetLabel)
        totalAssetLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(imageView).offset(0)
            make.top.equalTo(totalAssetTitleLabel.snp_bottom).offset(25)
            make.height.equalTo(33)
        }
        
        //累计收益
        let profitLabel = UILabel.init()
        profitLabel.textColor = UIColor.white
        profitLabel.font = UIFont.systemFont(ofSize: 13)
        profitLabel.textAlignment = .center
        profitLabel.tag = 201
        imageView.addSubview(profitLabel)
        profitLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(imageView).offset(0)
            make.top.equalTo(totalAssetLabel.snp_bottom).offset(20)
            make.height.equalTo(13)
        }
        return imageView
    }()
    
    //提币充币
    lazy var operationView:UIView = {
        let view = UIView.init()
        view.isUserInteractionEnabled = true
        //提币
        let withdrawView = UIView.init()
        withdrawView.backgroundColor = FYColor.operationColor()
        withdrawView.layer.cornerRadius = 10.0
        withdrawView.clipsToBounds = true
        withdrawView.isUserInteractionEnabled = true
        withdrawView.tag = 300
        let withdrawTap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        withdrawView.addGestureRecognizer(withdrawTap)
        view.addSubview(withdrawView)
        withdrawView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.width.equalTo(165)
            make.top.bottom.equalTo(view).offset(0)
        }

        let withdrawImageView = UIImageView.init()
        withdrawImageView.image = UIImage(named: "coin_out")
        withdrawView.addSubview(withdrawImageView)
        withdrawImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(withdrawView.snp_centerX)
            make.width.equalTo(49)
            make.top.equalTo(withdrawView).offset(20)
            make.height.equalTo(49)
        }

        let withdrawTitleLabel = UILabel.init()
        withdrawTitleLabel.text = LanguageHelper.getString(key: "Withdraw money")
        withdrawTitleLabel.textColor = FYColor.goldColor()
        withdrawTitleLabel.font = UIFont.systemFont(ofSize: 15)
        withdrawTitleLabel.textAlignment = .center
        withdrawView.addSubview(withdrawTitleLabel)
        withdrawTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(withdrawView).offset(0)
            make.bottom.equalTo(withdrawView).offset(-20)
            make.height.equalTo(20)
        }

        //充币
        let chargeView = UIView.init()
        chargeView.backgroundColor = FYColor.operationColor()
        chargeView.layer.cornerRadius = 10.0
        chargeView.clipsToBounds = true
        chargeView.isUserInteractionEnabled = true
        chargeView.tag = 301
        let chargeViewTap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        chargeView.addGestureRecognizer(chargeViewTap)
        view.addSubview(chargeView)
        chargeView.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-15)
            make.width.equalTo(withdrawView.snp_width)
            make.top.bottom.equalTo(view).offset(0)
        }

        let chargeViewImageView = UIImageView.init()
        chargeViewImageView.image = UIImage(named: "coin_in")
        chargeView.addSubview(chargeViewImageView)
        chargeViewImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(chargeView.snp_centerX)
            make.width.equalTo(withdrawImageView.snp_width)
            make.top.equalTo(withdrawImageView.snp_top)
            make.height.equalTo(withdrawImageView.snp_height)
        }

        let chargeTitleLabel = UILabel.init()
        chargeTitleLabel.text = LanguageHelper.getString(key: "Coin charging")
        chargeTitleLabel.textColor = FYColor.goldColor()
        chargeTitleLabel.font = UIFont.systemFont(ofSize: 15)
        chargeTitleLabel.textAlignment = .center
        chargeView.addSubview(chargeTitleLabel)
        chargeTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(chargeView).offset(0)
            make.bottom.equalTo(withdrawTitleLabel.snp_bottom)
            make.height.equalTo(withdrawTitleLabel.snp_height)
        }
        
        return view
    }()
    
    //立即抢单
    lazy var rushOrderButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYTool.hexStringToUIColor(hexString: "#EBC186")
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.setTitle(LanguageHelper.getString(key: "Grab the order immediately"), for: .normal)
        button.setTitleColor(FYColor.rushColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setImage(UIImage(named: "Asset_Rush"), for: .normal)
        button.setImagePosition(position: .right, spacing: 80)
        button.tag = 400
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()

}

extension FYAssetsVC:JJMarqueeViewDelegate,JJMarqueeViewDataSource {
    //多少条数据
    func numberOfItems(_ marqueeView: JJMarqueeView) -> Int {
        return self.infoArray?.count ?? 0
    }
    
    //每条数据的内容
    func marqueeView(_ marqueeView: JJMarqueeView, cellForItemAt index: Int) -> NSAttributedString {
        let model = self.infoArray![index]
        let str = FYTool.formatEmailByStar(email: model.email ?? "") + LanguageHelper.getString(key: "Rush Order Succeed")
        let tempStr = str as NSString
        let r = tempStr.range(of: str)
        let att = NSMutableAttributedString.init(string: tempStr as String)
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: FYColor.goldColor(), range: r)
        return att
    }
}
