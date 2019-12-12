//
//  FYInformationCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/12.
//  Copyright © 2019 何志武. All rights reserved.
//  --首页资讯cell

import UIKit

class FYInformationCell: UITableViewCell {

    //标题
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.text = "这是一个标题这是一个标题"
        label.textColor = FYColor.goldColor()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //图片
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.backgroundColor = FYColor.goldColor()
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //内容
    lazy var contentLabel:UILabel = {
        let label = UILabel.init()
        label.text = "这是内容这是内容这是内容这是内容这是内容这是内容这是内容"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    //发布时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.text = "2小时前"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
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
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_left)
            make.width.equalTo(110)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
            make.height.equalTo(75)
        }
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp_right).offset(10)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.iconImageView.snp_top)
            make.bottom.equalTo(self).offset(-30)
        }
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentLabel.snp_left)
            make.right.equalTo(self.contentLabel.snp_right)
            make.bottom.equalTo(self.iconImageView.snp_bottom)
            make.height.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
