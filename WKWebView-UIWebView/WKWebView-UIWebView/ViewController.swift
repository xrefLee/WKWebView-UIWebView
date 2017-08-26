//
//  ViewController.swift
//  WKWebView-UIWebView
//
//  Created by lxf on 16/11/14.
//  Copyright © 2016年 lxf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let urlStr = "http://www.modengvip.com/rec/article/listmenuInit?longitude=116.42933774538&latitude=39.8426871528896&access_token=242975d3-39a1-4006-8e6b-d7f5af7a52d5"
//    "http://modengvip.com/guangchang/newpa/"
    
//    http://www.modengvip.com/rec/content_v2?cid=252281
    override func viewDidLoad() {
        super.viewDidLoad()
        creatBtn()
        
        
    }
    
    
    func creatBtn(){
        let OC_UIWebBtn = UIButton(type: UIButtonType.custom)
        let OC_WKWebBtn = UIButton(type: UIButtonType.custom)
        let swift_UIWebBtn = UIButton(type: UIButtonType.custom)
        let swift_WKWebBtn = UIButton(type: UIButtonType.custom)
        
        OC_UIWebBtn.setTitle("Objc-UIWebView", for: UIControlState.normal)
        OC_WKWebBtn.setTitle("Objc-WKWebView", for: UIControlState.normal)
        swift_UIWebBtn.setTitle("swift-UIWebView", for: UIControlState.normal)
        swift_WKWebBtn.setTitle("swift-WKWebView", for: UIControlState.normal)
        
        OC_UIWebBtn.frame = CGRect(x: 80, y: 100, width: 200, height: 40)
        OC_WKWebBtn.frame = CGRect(x: 80, y: 160, width: 200, height: 40)
        swift_UIWebBtn.frame = CGRect(x: 80, y: 220, width: 200, height: 40)
        swift_WKWebBtn.frame = CGRect(x: 80, y: 280, width: 200, height: 40)
        
        OC_UIWebBtn.backgroundColor = UIColor.orange
        OC_WKWebBtn.backgroundColor = UIColor.orange
        swift_UIWebBtn.backgroundColor = UIColor.orange
        swift_WKWebBtn.backgroundColor = UIColor.orange
        
        self.view.addSubview(OC_UIWebBtn)
        self.view.addSubview(OC_WKWebBtn)
        self.view.addSubview(swift_UIWebBtn)
        self.view.addSubview(swift_WKWebBtn)
        
        OC_UIWebBtn.addTarget(self, action: #selector(ViewController.loadWith_OC_UIWebView), for: UIControlEvents.touchUpInside)
        OC_WKWebBtn.addTarget(self, action: #selector(ViewController.loadWith_OC_WKWebView), for: UIControlEvents.touchUpInside)
        swift_UIWebBtn.addTarget(self, action: #selector(ViewController.loadWith_swift_UIWebView), for: UIControlEvents.touchUpInside)
        swift_WKWebBtn.addTarget(self, action: #selector(ViewController.loadWith_swift_WKWebView), for: UIControlEvents.touchUpInside)
    }
    
    func loadWith_OC_UIWebView(){
        
        let OC_UIWebView = OCUIWebViewLoadVC()
        OC_UIWebView.urlStr = urlStr
        self.navigationController?.pushViewController(OC_UIWebView, animated: true)
    }
    
    func loadWith_OC_WKWebView(){
        
    }
    
    func loadWith_swift_UIWebView(){
        
        let swiftUIWebVC = SwiftUIWebViewLoadVC()
        swiftUIWebVC.urlStr = urlStr
//        self.navigationController?.pushViewController(swiftUIWebVC, animated: true)
        self.present(swiftUIWebVC, animated: true) {
            
        }
    }
    
    func loadWith_swift_WKWebView(){
        let swiftWKWebVC = SwiftWKWebViewLoadVC()
        swiftWKWebVC.urlStr = urlStr
        self.navigationController?.pushViewController(swiftWKWebVC, animated: true)
    }
    
    
    
    
    



}

