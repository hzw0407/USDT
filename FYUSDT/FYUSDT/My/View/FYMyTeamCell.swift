//
//  FYMyTeamCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

class FYMyTeamCell: UITableViewCell {
    
    //邮箱
    lazy var emailLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //资产
    lazy var assetLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    //订单数
    lazy var orderNumberLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //收益
    lazy var profitLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    //为我产生的收益
    lazy var myProfitLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //线
    lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.lineColor()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = FYColor.mainColor()
        
        self.addSubview(self.emailLabel)
        self.emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.width.equalTo((FYScreenWidth - 30) / 2)
            make.top.equalTo(self).offset(20)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.assetLabel)
        self.assetLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(self.emailLabel.snp_width)
            make.top.equalTo(self.emailLabel.snp_top)
            make.height.equalTo(self.emailLabel.snp_height)
        }
        
        self.addSubview(self.orderNumberLabel)
        self.orderNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.emailLabel.snp_left)
            make.width.equalTo(self.emailLabel.snp_width)
            make.top.equalTo(self.emailLabel.snp_bottom).offset(10)
            make.height.equalTo(self.emailLabel.snp_height)
        }
        
        self.addSubview(self.profitLabel)
        self.profitLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.assetLabel)
            make.width.equalTo(self.assetLabel.snp_width)
            make.top.equalTo(self.orderNumberLabel.snp_top)
            make.height.equalTo(self.orderNumberLabel.snp_height)
        }
        
        self.addSubview(self.myProfitLabel)
        self.myProfitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.orderNumberLabel.snp_left)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.orderNumberLabel.snp_bottom).offset(10)
            make.height.equalTo(self.orderNumberLabel.snp_height)
        }
        
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(-0.5)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //刷新数据
    func refreshWithModel(model:FYMyTeamModel) {
        self.emailLabel.text = String(format: LanguageHelper.getString(key: "Email"), model.email ?? "")
        self.assetLabel.text = String(format: LanguageHelper.getString(key: "Assets1"), String(format: "%.2f", model.balance ?? 0))
        self.orderNumberLabel.text = String(format: LanguageHelper.getString(key: "Order number"), model.orderNum ?? 0)
        self.profitLabel.text = String(format: LanguageHelper.getString(key: "Profit1"), String(format: "%.2f", model.getBalance ?? 0))
        
        let str = NSMutableAttributedString(string: String(format: LanguageHelper.getString(key: "Income generated for me"), String(format: "%.2f", model.upBalance ?? 0)))
        str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: str.length))
        if FYTool.getLanguageType() == "en-CN" {
            str.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], range: NSRange(location: 0, length: 23))
            str.addAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], range: NSRange(location: 23, length: str.length - 23))
        }else {
            str.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], range: NSRange(location: 0, length: 7))
            str.addAttributes([NSAttributedString.Key.foregroundColor:FYColor.goldColor()], range: NSRange(location: 7, length: str.length - 7))
        }
        self.myProfitLabel.attributedText = str
    }

}
