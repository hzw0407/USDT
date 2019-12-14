//
//  GScanManager.swift
//  Scan
//
//  Created by gqshi on 2019/6/14.
//  Copyright © 2019 develop. All rights reserved.
//

import UIKit
import AVFoundation;
@objc
class GScanManager: NSObject {
    var resultDelegate: ScanResultDelegate?
    var scanResultComplete: ScanCompleteAction?
    var input: AVCaptureDeviceInput?
    var scanLayer : AVCaptureVideoPreviewLayer?
    var parentView:UIView?
    lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    lazy var session:AVCaptureSession = AVCaptureSession()
    init(metadataTypes:[AVMetadataObject.ObjectType]?,rect:CGRect,view:UIView?,complete:ScanCompleteAction?) {

        scanResultComplete = complete;
        super.init();

        guard let superView = view  else {
            return;
        }

        let device = AVCaptureDevice.default(for: .video);
        guard let avDevice = device else {
            return;
        }
        input = try? AVCaptureDeviceInput.init(device: avDevice);
        guard let sessionInput = input else {
            return;
        }
        output.setMetadataObjectsDelegate(self, queue: .main);
        if .zero != rect {
            output.rectOfInterest = rect;
        }
        session.sessionPreset = .high;
        if session.canAddInput(sessionInput) {
            session.addInput(sessionInput)
        }
        if session.canAddOutput(output) {
            session.addOutput(output);
        }
        output.metadataObjectTypes = metadataTypes ?? [.qr,.upce,.code39,.code39Mod43,.ean13,.ean8,.code93,.code128,.pdf417,.aztec,.interleaved2of5,.itf14,.dataMatrix];
        scanLayer = AVCaptureVideoPreviewLayer(session: session);
        guard let layer = scanLayer else {
            return;
        }
        let videoView = UIView(frame: superView.bounds);
        parentView = videoView;
        videoView.backgroundColor = .clear;
        superView.insertSubview(videoView, at: 0);

        layer.videoGravity = .resizeAspectFill;
        var frame = superView.frame;
        frame.origin = .zero;
        layer.frame = superView.bounds;
        videoView.layer.insertSublayer(layer, at: 0);
    
        if avDevice.isFocusPointOfInterestSupported && avDevice.isFocusModeSupported(.autoFocus){
            try? sessionInput.device.lockForConfiguration();
            sessionInput.device.focusMode = .autoFocus;
            sessionInput.device.unlockForConfiguration();
        }
    }
    deinit {
        self.stopScan()
    }
}


extension GScanManager : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        let arr  = metadataObjects.filter { (metadata) -> Bool in
            return metadata is AVMetadataMachineReadableCodeObject;
            }.map{ (metadata) -> ScanResult in
                let obj = metadata as! AVMetadataMachineReadableCodeObject;
                return ScanResult(result: obj.stringValue ?? "" ,type:metadata.type);
        }
        if let complete = scanResultComplete {
            complete(arr,false);
        }
        if let delegate = resultDelegate {
            delegate.scanResult(arr, isLocal: false);
        }
    }
}

extension GScanManager:ScanDelegate{
    func startScan() {
        guard input != nil else {
            return;
        }
        guard !session.isRunning else {
            return;
        }
        guard let layer = videoLayer else {
            return;
        }
        session.startRunning();
        parentView?.layer.insertSublayer(layer, at: 0);
    }
    
    func stopScan() {
        guard session.isRunning else {
            return;
        }
        session.stopRunning();
    }
    
    func scanImage(_ image: UIImage?) {
        
    }
    
    func scanImage(_ data: Data?) {
        
    }
    
    func scanImage(_ file: String?) {
        
    }
    
    func scanImage(_ file: URL?) {
        
    }
    
    func takeTorch(_ isTorch: Bool) {
        guard let sessionInput = input else {
            return;
        }
        try? sessionInput.device.lockForConfiguration();
        sessionInput.device.torchMode = isTorch ? .on : .off;
        sessionInput.device.unlockForConfiguration();
    }
    
    var videoLayer: CALayer? {
        return scanLayer;
    }
}
