//
//  SwiftWKWebViewLoadVC.swift
//  WKWebView-UIWebView
//
//  Created by lxf on 16/11/14.
//  Copyright © 2016年 lxf. All rights reserved.
//

import UIKit
import WebKit


class SwiftWKWebViewLoadVC: UIViewController {

    
    var urlStr = "http://www.modengvip.com/rec/article/catlistboxInit?access_token=11032cd3-13da-473b-b256-6992e403aa52"
    let wkWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.frame = view.bounds
        wkWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(wkWebView)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wkWebView.load(URLRequest(url: URL(string: urlStr)!))
    }



}
