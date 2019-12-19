//
//  FYAdvertisementCell.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/12.
//  Copyright © 2019 何志武. All rights reserved.
//  --首页广告cell

import UIKit
import FSPagerView
import SnapKit
import Kingfisher

public protocol FYAdvertisementCellDelegate:class {
    //点击广告
    func clickIndex(index:Int)
}

class FYAdvertisementCell: UITableViewCell {

    var imageArray = [String]() {
        didSet {
            self.pagerControl.numberOfPages = imageArray.count
            self.pagerView.reloadData()
        }
    }
    
    public weak var delegate:FYAdvertisementCellDelegate?
    
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self as FSPagerViewDelegate
        pagerView.dataSource = self as FSPagerViewDataSource
        pagerView.automaticSlidingInterval = 2
        pagerView.isInfinite = !pagerView.isInfinite
        pagerView.layer.cornerRadius = 5.0
        pagerView.clipsToBounds = true
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FYAdvertisementCell")
        return pagerView
    }()
    
    lazy var pagerControl:FSPageControl = {
        let pageControl = FSPageControl()
        //设置下标的个数
        pageControl.numberOfPages = self.imageArray.count
        pageControl.contentHorizontalAlignment = .center
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器边框颜色（选中状态和普通状态）
//        pageControl.setStrokeColor(.red, for: .normal)
//        pageControl.setStrokeColor(.orange, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.gray, for: .normal)
        pageControl.setFillColor(.white, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        pageControl.setImage(UIImage.init(named: "banner-on-bg"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
//        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5),                 cornerRadius: 4.0), for: .normal)
//        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
//        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
        return pageControl

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
        
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        self.addSubview(self.pagerControl)
        self.pagerControl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(10)
        }
        self.pagerControl.numberOfPages = self.imageArray.count
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension FYAdvertisementCell:FSPagerViewDelegate,FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell: FSPagerViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "FYAdvertisementCell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: self.imageArray[index]))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pagerControl.currentPage = index
        self.delegate?.clickIndex(index: index)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex
    }
}
