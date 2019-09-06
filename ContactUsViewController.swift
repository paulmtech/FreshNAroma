//
//  ContactUsViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 17/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import WebKit
class ContactUsViewController: RootViewController, WKNavigationDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.freshnaroma.com/contact_mobile.php")!
        webView.load(URLRequest(url: url))
        activityView.startAnimating()
        webView.navigationDelegate = self
        activityView.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        title = webView.title
//    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
