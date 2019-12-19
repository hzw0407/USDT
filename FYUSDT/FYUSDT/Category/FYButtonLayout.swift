//
//  FYButtonLayout.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/10.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

extension UIButton {

    enum ImagePosition {
        case left   //image is left, label is right (图片在左，文字在右)
        case right  //image is right, label is left (图片在右，文字在左)
        case top    //image is top, label is bottom (图片在上，文字在下)
        case bottom //image is bottom, label is top (图片在下，文字在上)
    }
    
    func setImagePosition(position: ImagePosition, spacing: CGFloat) {
        guard let imageV = imageView else { return }
        guard let titleL = titleLabel else { return }
        //获取图像的宽和高
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        //获取文字的宽和高
        let labelWidth  = titleL.intrinsicContentSize.width
        let labelHeight = titleL.intrinsicContentSize.height

        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //UIButton同时有图像和文字的正常状态---左图像右文字，间距为0
        switch position {
        case .left:
            //正常状态--只不过加了个间距
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing * 0.5, bottom: 0, right: spacing * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing * 0.5, bottom: 0, right: -spacing * 0.5)
        case .right:
            //切换位置--左文字右图像
            //图像：UIEdgeInsets的left是相对于UIButton的左边移动了labelWidth + space * 0.5，right相对于label的左边移动了-labelWidth - space * 0.5
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + spacing * 0.5, bottom: 0, right: -labelWidth - spacing * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - spacing * 0.5, bottom: 0, right: imageWidth + spacing * 0.5)
        case .top:
            //切换位置--上图像下文字
            /**图像的中心位置向右移动了labelWidth * 0.5，向上移动了-imageHeight * 0.5 - space * 0.5
             *文字的中心位置向左移动了imageWidth * 0.5，向下移动了labelHeight*0.5+space*0.5
            */
//            imageEdgeInsets = UIEdgeInsets(top: -imageHeight * 0.5 - spacing * 0.5, left: labelWidth * 0.5, bottom: imageHeight * 0.5 + spacing * 0.5, right: -labelWidth * 0.5)
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - spacing / 2, left: 0, bottom: 0, right: -labelWidth)
//            labelEdgeInsets = UIEdgeInsets(top: labelHeight * 0.5 + spacing * 0.5 - spacing, left: -imageWidth, bottom: -labelHeight * 0.5 - spacing * 0.5, right: 0)
            labelEdgeInsets = UIEdgeInsets(top: labelHeight * 0.5 + spacing * 0.5, left: -((imageWidth + labelWidth/2) - (imageWidth + labelWidth)/2), bottom: -labelHeight * 0.5 - spacing * 0.5, right: (imageWidth + labelWidth/2) - (imageWidth + labelWidth)/2)
//            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing/2, right: 0)
        case .bottom:
            //切换位置--下图像上文字
            /**图像的中心位置向右移动了labelWidth * 0.5，向下移动了imageHeight * 0.5 + space * 0.5
             *文字的中心位置向左移动了imageWidth * 0.5，向上移动了labelHeight*0.5+space*0.5
             */
            imageEdgeInsets = UIEdgeInsets(top: imageHeight * 0.5 + spacing * 0.5, left: labelWidth * 0.5, bottom: -imageHeight * 0.5 - spacing * 0.5, right: -labelWidth * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: -labelHeight * 0.5 - spacing * 0.5, left: -imageWidth * 0.5, bottom: labelHeight * 0.5 + spacing * 0.5, right: imageWidth * 0.5)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets

    }

}
