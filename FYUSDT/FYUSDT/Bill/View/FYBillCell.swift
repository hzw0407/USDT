//
//  FYBillCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//  --账单cell

import UIKit

class FYBillCell: UITableViewCell {

    lazy var backGroundView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.rgb(34, 34, 34, 1)
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }()
    
    //盈亏
    lazy var YKLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //提现状态
    lazy var statusLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    //类型
    lazy var typeLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Recharge")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
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
        
        self.backgroundColor = FYColor.rgb(25, 25, 25, 1)
        
        self.addSubview(self.backGroundView)
        self.backGroundView.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(75)
        })
        
        self.backGroundView.addSubview(self.YKLabel)
        self.YKLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backGroundView).offset(15)
            make.width.equalTo((FYScreenWidth - 30) / 2)
            make.top.equalTo(self.backGroundView).offset(20)
            make.height.equalTo(11)
        }
        
        self.backGroundView.addSubview(self.statusLabel)
        self.statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.backGroundView).offset(-15)
            make.width.equalTo(self.YKLabel.snp_width)
            make.top.equalTo(self.YKLabel.snp_top)
            make.height.equalTo(self.YKLabel.snp_height)
        }
        
        self.backGroundView.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.YKLabel.snp_left)
            make.width.equalTo(self.YKLabel.snp_width)
            make.top.equalTo(self.YKLabel.snp_bottom).offset(15)
            make.height.equalTo(13)
        }
        
        self.backGroundView.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.backGroundView).offset(-15)
            make.width.equalTo(self.typeLabel.snp_width)
            make.top.equalTo(self.typeLabel.snp_top)
            make.height.equalTo(self.typeLabel.snp_height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func refreshWithModel(model:FYBillModel) {
        if (model.amount ?? 0) - 0.0 >= 0 {
            self.YKLabel.text = String(format: "+%.f USDT", model.amount ?? 0)
        }else {
            self.YKLabel.text = String(format: "%.f USDT", model.amount ?? 0)
        }
        if model.type == 2 || model.type == 5 {
            self.statusLabel.isHidden = false
            if model.status == 1 {
                //申请中
                self.statusLabel.text = LanguageHelper.getString(key: "Application1")
                self.statusLabel.textColor = FYColor.blueColor()
            }else if model.status == 2 {
                //已确认
                self.statusLabel.text = LanguageHelper.getString(key: "Confirmed")
                self.statusLabel.textColor = FYColor.greenColor()
            }else if model.status == 3 {
                //已拒绝
                self.statusLabel.text = LanguageHelper.getString(key: "Rejected")
                self.statusLabel.textColor = FYColor.redColor()
            }
        }else {
            self.statusLabel.isHidden = true
        }
        self.timeLabel.text = model.createTime
        if model.type == 1 {
            //充值
            self.typeLabel.text = LanguageHelper.getString(key: "Recharge")
            self.YKLabel.textColor = FYColor.greenColor()
        }else if model.type == 2 {
            //本金提现
            self.typeLabel.text =  LanguageHelper.getString(key: "Withdraw2")
            self.YKLabel.textColor = FYColor.redColor()
        }else if model.type == 3 {
            //投资收益
            self.typeLabel.text = LanguageHelper.getString(key: "Income from investment")
            self.YKLabel.textColor = FYColor.blueColor()
        }else if model.type == 4 {
            //推荐奖励
            self.typeLabel.text = LanguageHelper.getString(key: "Recommended Award")
            self.YKLabel.textColor = UIColor.orange
        }else {
            //收益提现
            self.typeLabel.text = LanguageHelper.getString(key: "Withdraw3")
            self.YKLabel.textColor = FYColor.redColor()
        }
    }

}
