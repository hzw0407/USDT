//
//  FYMyCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/13.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

public protocol FYMyCellDelegate:class {
    //注销登录
    func logout()
}

class FYMyCell: UITableViewCell {
    
    public weak var delegate:FYMyCellDelegate?

    lazy var backGroundView:UIView = {
        let view = UIView.init()
        view.backgroundColor = FYColor.rgb(34, 34, 34, 1)
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }()
    
    //图片
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    //标题
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //语言
    lazy var languageLabel:UILabel = {
        let label = UILabel.init()
        if FYTool.getLanguageType() == "en-CN" {
            label.text = LanguageHelper.getString(key: "English")
        }else {
            label.text = LanguageHelper.getString(key: "Simplified Chinese")
        }
        label.textColor = FYColor.grayColor()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //注销登录
    lazy var logoutButton:UIButton = {
        let button = UIButton.init()
        button.setTitle(LanguageHelper.getString(key: "Cancellation account"), for: .normal)
        button.setTitleColor(FYColor.goldColor(), for: .normal)
        button.setImage(UIImage(named: "quit"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setImagePosition(position: .left, spacing: 10)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    //箭头
    lazy var arrowImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "Arrow")
        return imageView
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
            make.height.equalTo(50)
        })
        
        self.backGroundView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.backGroundView).offset(17)
            make.width.equalTo(0)
            make.centerY.equalTo(self.backGroundView.snp_centerY)
            make.height.equalTo(0)
        }
        
        self.backGroundView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp_right).offset(10)
            make.width.equalTo(150)
            make.centerY.equalTo(self.backGroundView.snp_centerY)
            make.height.equalTo(20)
        }
        
        let languageWidth = FYTool.getTexWidth(textStr: self.languageLabel.text!, font: UIFont.systemFont(ofSize: 13), height: 20)
        self.backGroundView.addSubview(self.languageLabel)
        self.languageLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.width.equalTo(languageWidth + 5)
            make.centerY.equalTo(self.backGroundView.snp_centerY)
            make.height.equalTo(20)
        }
        
        self.backGroundView.addSubview(self.logoutButton)
        self.logoutButton.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.backGroundView).offset(0)
        }
        
        self.backGroundView.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.backGroundView).offset(-15)
            make.width.equalTo(15)
            make.centerY.equalTo(self.backGroundView.snp_centerY)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func refreshWithRow(row:Int,dict:[String:String]) {
        self.iconImageView.image = UIImage(named: dict["image"]!)
        self.titleLabel.text = dict["name"]!
        if row == 0 {
            self.iconImageView.snp.updateConstraints { (make) in
                make.width.equalTo(18)
                make.height.equalTo(22)
            }
        }else {
            self.iconImageView.snp.updateConstraints { (make) in
                make.width.height.equalTo(22)
            }
        }
        let titleWidth = FYTool.getTexWidth(textStr: self.titleLabel.text!, font: UIFont.systemFont(ofSize: 15), height: 20)
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp_right).offset(10)
            make.width.equalTo(titleWidth + 5)
        }
        
        if row == 8 {
            self.iconImageView.isHidden = true
            self.titleLabel.isHidden = true
            self.arrowImageView.isHidden = true
            self.logoutButton.isHidden = false
        }else {
            self.iconImageView.isHidden = false
            self.titleLabel.isHidden = false
            self.arrowImageView.isHidden = false
            self.logoutButton.isHidden = true
        }
        
        if row == 2 {
            self.languageLabel.isHidden = false
        }else {
            self.languageLabel.isHidden = true
        }
        
    }
    
    @objc func btnClick() {
        self.delegate?.logout()
    }

}
