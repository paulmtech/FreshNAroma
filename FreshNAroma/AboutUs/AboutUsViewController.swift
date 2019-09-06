//
//  AboutUsViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 18/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import WebKit


class AboutUsViewController: RootViewController ,  WKUIDelegate,WKNavigationDelegate {
    let urlString = String("https://www.freshnaroma.com/about_mobile.php")
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var webView: WKWebView!
   
    @IBOutlet weak var viewWebView: UIView!
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: viewWebView.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
       
        viewWebView.addSubview(webView)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:// WEBVIEW DELEGATE
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
         activity.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
   
        activity.isHidden = true
    }
    
    

    

}
