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
        label.text = "+1000.00 USDT"
        label.textColor = FYColor.greenColor()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //等待到账
    lazy var waitImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "wait")
        return imageView
    }()
    
    lazy var waitLabel:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Waiting for arrival")
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
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
        label.text = "2019-12-14 12:12:12"
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
            make.right.equalTo(self.backGroundView).offset(0)
            make.top.equalTo(self.backGroundView).offset(20)
            make.height.equalTo(11)
        }
        
        let waitWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Waiting for arrival"), font: UIFont.systemFont(ofSize: 10), height: 16)
        self.backGroundView.addSubview(self.waitImageView)
        self.waitImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.backGroundView)
            make.width.equalTo(waitWidth + 10)
            make.top.equalTo(self.backGroundView)
            make.height.equalTo(16)
        }
        
        self.waitImageView.addSubview(self.waitLabel)
        self.waitLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.waitImageView).offset(0)
        }
        
        self.backGroundView.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.YKLabel.snp_left)
            make.width.equalTo((FYScreenWidth - 30) / 2)
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

}
