//
//  FYRushOrderCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/13.
//  Copyright © 2019 何志武. All rights reserved.
//  --抢单cell

import UIKit
import UICircularProgressRing
import SwiftyFitsize

class FYRushOrderCell: UITableViewCell {
    
    //线
    lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.lineColor()
        return view
    }()

    //需求金额标题
    lazy var amountTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Demand amount")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        return label
    }()
    
    //需求金额
    lazy var amountLabel:UILabel = {
        let label = UILabel.init()
        let str = NSMutableAttributedString(string: "10000.00")
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: str.length))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25~)], range: NSRange(location: 0, length: str.length - 3))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13~)], range: NSRange(location: str.length - 3, length: 3))
        label.attributedText = str
        return label
    }()
    
    //预计年利化率标题
    lazy var rateTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Annual interest rate")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        return label
    }()
    
    //预计年利化率
    lazy var rateLabel:UILabel = {
        let label = UILabel.init()
        let str = NSMutableAttributedString(string: "6.0%")
        str.addAttributes([NSAttributedString.Key.foregroundColor: FYColor.goldColor()], range: NSRange(location: 0, length: str.length))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25~)], range: NSRange(location: 0, length: str.length - 1))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13~)], range: NSRange(location: str.length - 1, length: 1))
        label.attributedText = str
        return label
    }()
    
    //抢单
    lazy var rushButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYColor.goldColor()
        button.setTitle(LanguageHelper.getString(key: "Rush1"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15~)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    //进度圈
    lazy var cirleView:UICircularProgressRing = {
        let view = UICircularProgressRing.init()
        view.style = .ontop
        //最大值
        view.maxValue = 100.0
        //进度值颜色
        view.fontColor = FYColor.goldColor()
        //进度值大小
        view.font = UIFont.systemFont(ofSize: 10~)
        //外环
        view.outerRingWidth = 5.0
        //剩余的进度颜色
        view.outerRingColor = UIColor.gray
        //进度条颜色
        view.innerRingColor = FYColor.goldColor()
        return view
    }()
    
    //剩余额度标题
    lazy var surplusTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Surplus amount")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        return label
    }()
    
    //剩余额度
    lazy var surplusLabel:UILabel = {
        let label = UILabel.init()
        label.text = "12345.00"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15~)
        return label
    }()
    
    //用款天数
    lazy var dayLabel:UILabel = {
        let label = UILabel.init()
        label.text = String(format: LanguageHelper.getString(key: "Payment days"), 1)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        return label
    }()
    
    //剩余时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.text = String(format: LanguageHelper.getString(key: "Remaining time"), "01:20:30")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        return label
    }()
    
    //定时器
    var timer:Timer?
    var countTime = arc4random() % 1000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = FYColor.mainColor()
        
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15~)
            make.right.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(0.5)
        }
        
        let amountTitleWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Demand amount"), font: UIFont.systemFont(ofSize: 13~), height: 20~)
        self.addSubview(self.amountTitleLabel)
        self.amountTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp_left)
            make.width.equalTo(amountTitleWidth~ + 30~)
            make.top.equalTo(self.lineView.snp_bottom).offset(20~)
            make.height.equalTo(20~)
        }
        
        self.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.amountTitleLabel.snp_left)
            make.width.equalTo(self.amountTitleLabel.snp_width)
            make.top.equalTo(self.amountTitleLabel.snp_bottom).offset(15~)
            make.height.equalTo(self.amountTitleLabel.snp_height)
        }
        
        let rateTitleWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Annual interest rate"), font: UIFont.systemFont(ofSize: 13~), height: 20~)
        self.addSubview(self.rateTitleLabel)
        self.rateTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.amountTitleLabel.snp_right)
            make.width.equalTo(rateTitleWidth~ + 5~)
            make.top.equalTo(self.amountTitleLabel.snp_top)
            make.height.equalTo(self.amountTitleLabel.snp_height)
        }
        
        self.addSubview(self.rateLabel)
        self.rateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.rateTitleLabel.snp_left)
            make.width.equalTo(self.rateTitleLabel.snp_width)
            make.top.equalTo(self.amountLabel.snp_top)
            make.height.equalTo(self.rateTitleLabel.snp_height)
        }
        
        let rushWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Rush1"), font: UIFont.systemFont(ofSize: 15~), height: 45~)
        self.addSubview(self.rushButton)
        self.rushButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15~)
            make.width.equalTo(rushWidth~ + 5~ > 80~ ? rushWidth~ + 5~ : 80~)
            make.top.equalTo(self.rateTitleLabel.snp_top)
            make.height.equalTo(45~)
        }
        self.rushButton.layoutIfNeeded()
        self.rushButton.layer.cornerRadius = 45~ / 2.0
        
        self.addSubview(self.cirleView)
        self.cirleView.snp.makeConstraints { (make) in
            make.left.equalTo(self.amountLabel.snp_left)
            make.width.equalTo(35~)
            make.top.equalTo(self.amountLabel.snp_bottom).offset(20~)
            make.height.equalTo(35~)
        }
        //设置进度
        self.cirleView.startProgress(to: 30, duration: 0.1)
        
        self.addSubview(self.surplusTitleLabel)
        self.surplusTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.cirleView.snp_right).offset(10~)
            make.width.equalTo(150~)
            make.top.equalTo(self.cirleView.snp_top)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.surplusLabel)
        self.surplusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.surplusTitleLabel.snp_left)
            make.width.equalTo(self.surplusTitleLabel.snp_width)
            make.top.equalTo(self.surplusTitleLabel.snp_bottom)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        let timeWidth = FYTool.getTexWidth(textStr: self.timeLabel.text!, font: UIFont.systemFont(ofSize: 13~), height: 20~)
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15~)
            make.width.equalTo(timeWidth~ + 10~)
            make.top.equalTo(self.surplusTitleLabel.snp_top)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.dayLabel.snp_right)
            make.width.equalTo(self.dayLabel.snp_width)
            make.bottom.equalTo(self.surplusLabel.snp_bottom)
            make.height.equalTo(self.dayLabel.snp_height)
        }
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func btnClick() {
        
    }
    
    @objc func countDown() {
        self.countTime -= 1
        self.timeLabel.text = String(format: LanguageHelper.getString(key: "Remaining time"), FYTool.transToHourMinSec(time: Int(self.countTime)))
        let timeWidth = FYTool.getTexWidth(textStr: self.timeLabel.text!, font: UIFont.systemFont(ofSize: 13~), height: 20~)
        self.dayLabel.snp.updateConstraints { (make) in
            make.width.equalTo(timeWidth~ + 10~)
        }
        self.timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.dayLabel.snp_width)
        }
        if self.countTime <= 0 {
            self.timer?.invalidate()
            self.timer = nil
        }
    }

}
