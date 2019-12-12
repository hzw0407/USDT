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
        self.setTitle(self.currentTitle, for: .normal)
        self.setImage(self.currentImage, for: .normal)
        
        // MARK - ImageSize
        var imageW: CGFloat = 0
        if let width = imageView?.image?.size.width {
            imageW = width
        } else {
            assertionFailure("image can't be nil(图片不能为空)")
        }
        
        var imageH: CGFloat = 0
        if let height = imageView?.image?.size.height {
            imageH = height
        }
        
        // MARK - LabelSize
        assert(titleLabel != nil, "label be nil(文字不能为空)")
        
        var labelW: CGFloat = 0
        if let width = titleLabel?.frame.size.width {
            labelW = width
        }
        
        var labelH: CGFloat = 0
        if let height = titleLabel?.frame.size.height {
            labelH = height
        }
        
        let imageOffsetX = (imageW + labelW)/2 - imageW/2
        let imageOffsetY = imageH/2 + spacing/2
        
        let labelOffsetX = (imageW + labelW/2) - (imageW + labelW)/2
        let labelOffsetY = labelH/2 + spacing/2
        
        let tempW = max(labelW, imageW)
        let changedW = labelW + imageW - tempW
        
        let tempH = max(labelH, imageH)
        let changedH = labelH + imageH + spacing - tempH
        
        switch position {
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelW + spacing/2, bottom: 0, right: -(labelW + spacing/2))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageW + spacing/2), bottom: 0, right: imageW + spacing/2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedW/2, bottom: changedH-imageOffsetY, right: -changedW/2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedH-imageOffsetY, left: -changedW/2, bottom: imageOffsetY, right: -changedW/2)
        }
        
    }

}
