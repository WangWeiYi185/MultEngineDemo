//
//  WebContainer.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/18.
//

import UIKit
import WebKit


class YCWebContainer: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"localhost:8080")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
