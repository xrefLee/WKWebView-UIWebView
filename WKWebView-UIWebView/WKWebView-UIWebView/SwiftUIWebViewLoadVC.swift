//
//  SwiftUIWebViewLoadVC.swift
//  WKWebView-UIWebView
//
//  Created by lxf on 16/11/14.
//  Copyright © 2016年 lxf. All rights reserved.
//

import UIKit
/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 自适应比例
class SwiftUIWebViewLoadVC: UIViewController {
    
    var urlStr = "http://www.modengvip.com/rec/article/catlistboxInit?access_token=11032cd3-13da-473b-b256-6992e403aa52"
    let webView = UIWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.frame = view.bounds
        webView.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: kScreenHeight - 49)
        webView.scalesPageToFit = false
        view.addSubview(webView)
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
        
    }

   
}
