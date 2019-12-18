//
//  FYHomeDetailVC.swift
//  FYUSDT
//
//  Created by 何志武 on 2019/12/18.
//  Copyright © 2019 何志武. All rights reserved.
//

import UIKit
import WebKit

class FYHomeDetailVC: UIViewController {
    
    var urlStr:String?
    
    //返回按钮
    lazy var backButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "arrow_left"), for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    lazy var webView:WKWebView = {
        let webView = WKWebView.init()
        webView.backgroundColor = FYColor.mainColor()
        webView.uiDelegate = self as WKUIDelegate
        webView.navigationDelegate = self as WKNavigationDelegate
        return webView
    }()
    
    //pragma mark - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = FYColor.mainColor()
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(28)
            make.top.equalTo(self.view).offset(50)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view).offset(0)
            make.top.equalTo(self.backButton.snp_bottom).offset(30)
        }
        self.webView.load(URLRequest(url: URL(string: self.urlStr ?? "")!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    //pragma mark - CustomMethod

    //pragma mark - ClickMethod
    @objc func btnClick() {
        self.navigationController?.popViewController(animated: true)
    }

    //pragma mark - SystemDelegate

    //pragma mark - CustomDelegate

    //pragma mark - GetterAndSetter
    

}

@available(iOS 8.0, *)
extension FYHomeDetailVC:WKUIDelegate,WKNavigationDelegate {
    
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        MBProgressHUD.showWait(LanguageHelper.getString(key: "Loading"))
    }
    
    //加载完成
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        var webheight = 0.0
//
//        // 获取内容实际高度
//        self.webView.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
//
//            if let tempHeight: Double = result as? Double {
//                webheight = tempHeight
//                self.webView.snp.updateConstraints({ (make) in
//                    make.height.equalTo(webheight)
//                })
//                let titleHeight = OTTool.getTextHeigh(textStr: self.tempModel!.title, font: UIFont.systemFont(ofSize: 22)~, width: UIScreen.main.bounds.size.width - 40~)
//                let fdf = CGFloat(webheight)
//                let sfdsd = 20~ + titleHeight + 5~ + 30~ + 40~ + 20~ + fdf + 10~
//                self.scrollView.layoutIfNeeded()
//                self.scrollView.contentSize = CGSize(width: 0, height: fdf + sfdsd)
//            }
//        }
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        MBProgressHUD.hideHUD()
        MBProgressHUD.showInfo(LanguageHelper.getString(key: "Failed to load"))
    }
}
