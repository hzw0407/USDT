//
//  FYOrderCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/13.
//  Copyright © 2019 何志武. All rights reserved.
//  --订单cell

import UIKit
import UICircularProgressRing
import YYText

class FYOrderCell: UITableViewCell {

    //线
    lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.lineColor()
        return view
    }()
    
    //下单金额标题
    lazy var amountTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Order amount")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //下单金额
    lazy var amountLabel:UILabel = {
        let label = UILabel.init()
        let str = NSMutableAttributedString(string: "10000.00")
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: str.length))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: str.length - 3))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: str.length - 3, length: 3))
        label.attributedText = str
        return label
    }()
    
    //预计收益标题
    lazy var revenueTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Estimated revenue")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //预计收益
    lazy var revenueLabel:UILabel = {
        let label = UILabel.init()
        let str = NSMutableAttributedString(string: "100.00")
        str.addAttributes([NSAttributedString.Key.foregroundColor: FYColor.goldColor()], range: NSRange(location: 0, length: str.length))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)], range: NSRange(location: 0, length: str.length - 3))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSRange(location: str.length - 3, length: 3))
        label.attributedText = str
        return label
    }()
    
    //用款天数标题
    lazy var dayTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Payment days (days)")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    //用款天数
    lazy var dayLabel:UILabel = {
        let label = UILabel.init()
        label.text = "30"
        label.textColor = FYColor.grayColor()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .right
        return label
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
        view.font = UIFont.systemFont(ofSize: 10)
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
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //剩余额度
    lazy var surplusLabel:UILabel = {
        let label = UILabel.init()
        label.text = "12345.00"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //结算时间标题
    lazy var closetitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Close time")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    //结算时间
    lazy var closeLabel:UILabel = {
        let label = UILabel.init()
        label.text = "2019-12-13 18:20:30"
        label.textColor = FYColor.grayColor()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    //下单时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.text = String(format: LanguageHelper.getString(key: "Order time"), "2019-12-12 12:12:12")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    //参与人数
    lazy var participatedLabel:YYLabel = {
        let label = YYLabel.init()
        let tempStr:String = String(format: LanguageHelper.getString(key: "people have participated"), "10")
        let str = NSMutableAttributedString(string: tempStr)
        str.yy_font = UIFont.systemFont(ofSize: 10)
        if FYTool.getLanguageType() == "en-CN" {
            //英文
            str.yy_setColor(FYColor.goldColor(), range: NSRange(location: 0, length: 2))
            str.yy_setColor(UIColor.gray, range: NSRange(location: 2, length: str.length - 2))
        }else {
            //中文
            str.yy_setColor(UIColor.gray, range: NSRange(location: 0, length: 2))
            str.yy_setColor(FYColor.goldColor(), range: NSRange(location: 3, length: 2))
            str.yy_setColor(UIColor.gray, range: NSRange(location: 5, length: str.length - 5))
        }
        label.attributedText = str
        label.textAlignment = .right
        return label
    }()
    
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
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(0.5)
        }
        
        let amountWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Order amount"), font: UIFont.systemFont(ofSize: 13), height: 20)
        self.addSubview(self.amountTitleLabel)
        self.amountTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp_left)
            make.width.equalTo(amountWidth + 5)
            make.top.equalTo(self.lineView.snp_bottom).offset(20)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.amountTitleLabel.snp_left)
            make.width.equalTo(self.amountTitleLabel.snp_width)
            make.top.equalTo(self.amountTitleLabel.snp_bottom).offset(15)
            make.height.equalTo(self.amountTitleLabel.snp_height)
        }
        
        let revenueWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Estimated revenue"), font: UIFont.systemFont(ofSize: 13), height: 20)
        self.addSubview(self.revenueTitleLabel)
        self.revenueTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(revenueWidth + 5)
            make.top.equalTo(self.amountTitleLabel.snp_top)
            make.height.equalTo(self.amountTitleLabel.snp_height)
        }
        
        self.addSubview(self.revenueLabel)
        self.revenueLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(self.revenueTitleLabel.snp_width)
            make.top.equalTo(self.amountLabel.snp_top)
            make.height.equalTo(self.revenueTitleLabel.snp_height)
        }
        
        let dayWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Payment days (days)"), font: UIFont.systemFont(ofSize: 13), height: 20)
        self.addSubview(self.dayTitleLabel)
        self.dayTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(dayWidth + 5)
            make.top.equalTo(self.revenueTitleLabel.snp_top)
            make.height.equalTo(self.revenueTitleLabel.snp_height)
        }
        
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.dayTitleLabel.snp_right)
            make.width.equalTo(self.dayTitleLabel.snp_width)
            make.top.equalTo(self.revenueLabel.snp_top)
            make.height.equalTo(self.dayTitleLabel.snp_height)
        }
        
        self.addSubview(self.cirleView)
        self.cirleView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.width.equalTo(35)
            make.top.equalTo(self.amountLabel.snp_bottom).offset(25)
            make.height.equalTo(35)
        }
        self.cirleView.startProgress(to: 30, duration: 0.1)
        
        let surplusWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Surplus amount"), font: UIFont.systemFont(ofSize: 13), height: 20)
        self.addSubview(self.surplusTitleLabel)
        self.surplusTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.cirleView.snp_right).offset(10)
            make.width.equalTo(surplusWidth + 5)
            make.top.equalTo(self.cirleView.snp_top)
            make.height.equalTo(self.amountLabel.snp_height)
        }
        
        self.addSubview(self.surplusLabel)
        self.surplusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.surplusTitleLabel.snp_left)
            make.width.equalTo(self.surplusTitleLabel.snp_width)
            make.top.equalTo(self.surplusTitleLabel.snp_bottom)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        self.addSubview(self.closetitleLabel)
        self.closetitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-25)
            make.width.equalTo(130)
            make.top.equalTo(self.surplusTitleLabel.snp_top)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        self.addSubview(self.closeLabel)
        self.closeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.closetitleLabel.snp_right)
            make.width.equalTo(self.closetitleLabel.snp_width)
            make.top.equalTo(self.surplusLabel.snp_top)
            make.height.equalTo(self.closetitleLabel.snp_height)
        }
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo((FYScreenWidth - 30) / 2)
            make.top.equalTo(self.cirleView.snp_bottom).offset(20)
            make.height.equalTo(10)
        }
        
        self.addSubview(self.participatedLabel)
        self.participatedLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(self.timeLabel.snp_width)
            make.top.equalTo(self.timeLabel.snp_top)
            make.height.equalTo(self.timeLabel.snp_height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}