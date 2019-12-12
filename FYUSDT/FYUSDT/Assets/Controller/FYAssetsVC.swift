//
//  FYAssetsVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/12.
//  Copyright © 2019 何志武. All rights reserved.
//  --资产

import UIKit

class FYAssetsVC: UIViewController {
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod

    //pragma mark - ClickMethod

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter

}
