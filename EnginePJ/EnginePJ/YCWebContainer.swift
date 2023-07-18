//
//  WebContainer.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/18.
//

import UIKit
import WebKit


class YCWebContainer: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()

        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    

    


    override func viewDidLoad() {
        super.viewDidLoad()
        // 解决本地 1004问题 两个怀疑方向， 1:跨域 2:https
        let myURL = URL(string:"http://10.181.141.192")
//        let myURL = URL(string:"http://localhost:8080")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
