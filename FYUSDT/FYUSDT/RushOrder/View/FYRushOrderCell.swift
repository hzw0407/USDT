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

public protocol FYRushOrderCellDelegate:class {
    //倒计时结束
    func countDownEnd()
    //点击抢单
    func rushClick(index:Int)
}

class FYRushOrderCell: UITableViewCell {
    
    public weak var delegate:FYRushOrderCellDelegate?
    
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
        return label
    }()
    
    //抢单
    lazy var rushButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = FYColor.goldColor()
        button.setTitle(LanguageHelper.getString(key: "Rush1"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15~)
        button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
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
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15~)
        return label
    }()
    
    //用款天数
    lazy var dayLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        label.textAlignment = .right
        return label
    }()
    
    //剩余时间
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13~)
        label.textAlignment = .right
        return label
    }()
    
    //定时器
    var timer:Timer?
    //倒计时秒数
    var countTime:Int?
    
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
            make.width.equalTo(amountTitleWidth + 30~)
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
            make.width.equalTo(rateTitleWidth + 5~)
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
            make.width.equalTo(rushWidth + 5~ > 80~ ? rushWidth + 5~ : 80~)
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
        
        let surplusTitleWidth = FYTool.getTexWidth(textStr: LanguageHelper.getString(key: "Surplus amount"), font: UIFont.systemFont(ofSize: 13~), height: 20~)
        self.addSubview(self.surplusTitleLabel)
        self.surplusTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.cirleView.snp_right).offset(10~)
            make.width.equalTo(surplusTitleWidth + 5~)
            make.top.equalTo(self.cirleView.snp_top)
            make.height.equalTo(20~)
        }
        
        self.addSubview(self.surplusLabel)
        self.surplusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.surplusTitleLabel.snp_left)
            make.width.equalTo(self.surplusTitleLabel.snp_width)
            make.top.equalTo(self.surplusTitleLabel.snp_bottom)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.surplusTitleLabel.snp_right).offset(5~)
            make.right.equalTo(self).offset(-15~)
            make.top.equalTo(self.surplusTitleLabel.snp_top)
            make.height.equalTo(self.surplusTitleLabel.snp_height)
        }
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dayLabel.snp_left)
            make.right.equalTo(self.dayLabel.snp_right)
            make.bottom.equalTo(self.surplusLabel.snp_bottom)
            make.height.equalTo(self.dayLabel.snp_height)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //点击抢单
    @objc func btnClick(btn:UIButton) {
        self.delegate?.rushClick(index: btn.tag)
    }
    
    @objc func countDown() {
        self.countTime! -= 1
        self.timeLabel.text = String(format: LanguageHelper.getString(key: "Remaining time"), FYTool.transToHourMinSec(time: self.countTime!))
        if self.countTime! <= 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.delegate?.countDownEnd()
        }
    }
    
    //刷新数据
    public func refreshWithModel(model:FYRushOrderModel,index:Int) {
        self.rushButton.tag = index
        
        let amountStr = NSMutableAttributedString(string: String(format: "%.2f", model.demandAmount ?? 0))
        amountStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: amountStr.length))
        amountStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25~)], range: NSRange(location: 0, length: amountStr.length - 3))
        amountStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13~)], range: NSRange(location: amountStr.length - 3, length: 3))
        self.amountLabel.attributedText = amountStr
        
        let rateStr = NSMutableAttributedString(string: String(format: "%.1f%%", (model.rewardRate ?? 0) * Double(100)))
        rateStr.addAttributes([NSAttributedString.Key.foregroundColor: FYColor.goldColor()], range: NSRange(location: 0, length: rateStr.length))
        rateStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25~)], range: NSRange(location: 0, length: rateStr.length - 1))
        rateStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13~)], range: NSRange(location: rateStr.length - 1, length: 1))
        self.rateLabel.attributedText = rateStr
        
        //设置进度
        self.cirleView.startProgress(to: CGFloat(((model.surplusAmount ?? 0) / (model.demandAmount ?? 0)) * Double(100)), duration: 0.1)
        
        self.surplusLabel.text = String(format: "%.2f", model.surplusAmount ?? 0)
        self.dayLabel.text = String(format: LanguageHelper.getString(key: "Payment days"), model.useNum ?? 0)
        self.timeLabel.text = String(format: LanguageHelper.getString(key: "Remaining time"), FYTool.transToHourMinSec(time: model.timeNum ?? 0))
        
        self.countTime = model.timeNum ?? 0
        if model.timeNum ?? 0 > 0 {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
            }
        }
    }

}
