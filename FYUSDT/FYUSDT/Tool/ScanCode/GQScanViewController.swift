//
//  GQScanViewController.swift
//  Scan
//
//  Created by 何志武 on 2019/12/11.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit

public protocol GQScanViewControllerDelegate:class {
    //返回扫描的数据
    func scanResult(result:String)
}

class GQScanViewController: UIViewController {
    
    var scanManager : ScanDelegate?;
    public weak var delegate:GQScanViewControllerDelegate?
    
    init(scan:ScanDelegate?){
        scanManager = scan;
        super.init(nibName: nil, bundle: nil);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if scanManager == nil {
            scanManager = GScanManager(metadataTypes: nil, rect: .zero, view: self.view, complete: { (result,isLocal ) in
                for item in result {
                    self.scanManager?.stopScan()
                    self.delegate?.scanResult(result: "\(item.result)")
                    self.navigationController?.popViewController(animated: true)
                    
                }
            });
        }
        self.view.backgroundColor = .white;
        
        scanManager?.startScan()
        
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(named: "Back1"), for: UIControl.State.normal)
        leftButton.addTarget(self, action: #selector(leftClick), for: UIControl.Event.touchUpInside)
        let leftItem:UIBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let scanImageView = UIImageView.init()
        scanImageView.image = UIImage(named: "code-bg")
        self.view.addSubview(scanImageView)
        scanImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(200)
            make.centerY.equalTo(self.view.snp_centerY).offset(-navigationHeight)
            make.height.equalTo(200)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func leftClick() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension GQScanViewController: ScanResultDelegate{
    func scanResult(_ result: [ScanResult], isLocal: Bool) {
        for item in result {
//            print("result = \(item.result)");
        }
    }
}
