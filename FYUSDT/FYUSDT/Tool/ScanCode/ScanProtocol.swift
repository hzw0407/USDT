//
//  ScanProtocol.swift
//  Scan
//
//  Created by gqshi on 2019/6/14.
//  Copyright © 2019 develop. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct ScanResult {
    var result:String
    var type : AVMetadataObject.ObjectType
}

/// 扫码回调
typealias ScanCompleteAction = (_ result:[ScanResult],_ isLocal:Bool)->Void;
/// 扫码结果协议
protocol ScanResultDelegate {
    /// 扫码得到的结果
    ///
    /// - Parameters:
    ///   - result: 结果数组
    ///   - isLocal: 是否是扫描的传递过来的图片
    func scanResult(_ result:[ScanResult],isLocal:Bool);
}

/// 扫码功能协议
protocol ScanDelegate {
    /// 结果代理
    var resultDelegate:ScanResultDelegate? { set get };
    
    /// 扫码结果闭包
    var scanResultComplete:ScanCompleteAction? { set get };
    
    /// 扫码layer
    var videoLayer:CALayer? { get }
    
    /// 开始相机扫描
    func startScan();
    
    /// 停止相机扫描
    func stopScan();
    
    /// 扫描图片
    ///
    /// - Parameters:
    ///   - image: 图片对象
    func scanImage(_ image:UIImage?);
    
    /// 扫描图片
    ///
    /// - Parameters:
    ///   - data: 图片data
    func scanImage(_ data:Data?);
    
    /// 扫描图片
    ///
    /// - Parameters:
    ///   - file: 图片本地路径
    func scanImage(_ file:String?);
    
    /// 扫描图片
    ///
    /// - Parameters:
    ///   - file: 图片本地路径URL
    func scanImage(_ file:URL?);
    
    /// 开关闪光灯
    ///
    /// - Parameter isTorch: true:开启,false:关闭
    func takeTorch(_ isTorch:Bool);
}
