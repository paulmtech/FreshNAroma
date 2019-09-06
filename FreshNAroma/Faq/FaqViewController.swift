//
//  FaqViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 19/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import WebKit


class FaqViewController: RootViewController ,  WKUIDelegate,WKNavigationDelegate {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var webView: WKWebView!
    let urlString = String("https://www.freshnaroma.com/faq_mobile.php")
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


