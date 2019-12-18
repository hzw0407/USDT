//
//  FYApplicationCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/14.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

class FYApplicationCell: UITableViewCell {

    //背景图
    lazy var backGroundImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "code_bg")
        return imageView
    }()
    
    //邀请码标题
    lazy var codeTitleLbale:UILabel = {
        let label = UILabel.init()
        label.text = LanguageHelper.getString(key: "Invitation code")
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    //邀请码
    lazy var codeButton:UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    //申请时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //状态
    lazy var statusLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = FYColor.greenColor()
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
        
        self.backgroundColor = FYColor.rgb(25, 25, 25, 1.0)
        
        self.addSubview(self.backGroundImageView)
        self.backGroundImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(123)
        }
        
        self.backGroundImageView.addSubview(self.codeTitleLbale)
        self.codeTitleLbale.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.backGroundImageView).offset(0)
            make.top.equalTo(self.backGroundImageView).offset(15)
            make.height.equalTo(12.5)
        }
        
        self.backGroundImageView.addSubview(self.codeButton)
        self.codeButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.backGroundImageView).offset(0)
            make.top.equalTo(self.codeTitleLbale.snp_bottom).offset(15)
            make.height.equalTo(22)
        }
        
        self.backGroundImageView.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backGroundImageView).offset(15)
            make.width.equalTo(300)
            make.bottom.equalTo(self.backGroundImageView).offset(-15)
            make.height.equalTo(12.5)
        }
        
        self.backGroundImageView.addSubview(self.statusLabel)
        self.statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.backGroundImageView).offset(-15)
            make.width.equalTo(70)
            make.bottom.equalTo(self.timeLabel.snp_bottom)
            make.height.equalTo(self.timeLabel.snp_height)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func btnClick(btn:UIButton) {
        UIPasteboard.general.string = btn.titleLabel?.text!
        MBProgressHUD.showInfo(LanguageHelper.getString(key: "copy_success"))
    }
    
    //刷新数据
    func refreshWithModel(model:FYApplicationRecordModel) {
        if model.userInviteCode != nil {
            self.codeButton.setTitle(model.userInviteCode, for: .normal)
            self.codeButton.setImage(UIImage(named: "copy"), for: .normal)
            self.codeButton.setImagePosition(position: .right, spacing: 15)
        }
        self.timeLabel.text = String(format: LanguageHelper.getString(key: "Application time"), model.createTime ?? "")
        if model.status == 0 {
            //申请中
            self.statusLabel.text = LanguageHelper.getString(key: "Application")
            self.statusLabel.textColor = FYColor.blueColor()
        }else if model.status == 1 {
            //审核拒绝
            self.statusLabel.text = LanguageHelper.getString(key: "Audit reject")
            self.statusLabel.textColor = FYColor.redColor()
        }else if model.status == 2 {
            //已发放
            self.statusLabel.text = LanguageHelper.getString(key: "Have been issued")
            self.statusLabel.textColor = FYColor.greenColor()
        }else if model.status == 3 {
            //已使用
            self.statusLabel.text = LanguageHelper.getString(key: "Already used")
            self.statusLabel.textColor = FYColor.placeholderColor()
        }
    }

}
