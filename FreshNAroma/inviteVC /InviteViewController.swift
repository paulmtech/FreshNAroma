//
//  InviteViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 10/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDynamicLinks

class InviteViewController: RootViewController,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var btnInviteAFriend: UIButton!
    @IBOutlet weak var btnSocialShare: UIButton!
    var inviteMessage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSocialShare.roundCorners(cornerRadius: 5)
            btnInviteAFriend.roundCorners(cornerRadius: 5)
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            let code = (userCode![UserDefaulKey.code]! as? String)!
           txtCode.text = code
            
           // let shareURLLink = URL(string:"https://www.freshnaroma.com/refferal?code = \(code)")
            // inviteMessage = "Use FRESH N AROMA for grocery purchase! use my code \(code) get a free ₹50 for registration. link - http://onelink.to/freshnaroma"
            var components = URLComponents()
                components.scheme = "https"
                components.host = "www.freshnaroma.com"
                components.path = "/referral"
            
            let recipeIDQueryItems = URLQueryItem(name: "code", value: code)
            
            components.queryItems = [recipeIDQueryItems]
            guard let linkParameter = components.url else {
                return
            }
           
            guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://fna.page.link") else {
                return
            }
            if let myBundalID = Bundle.main.bundleIdentifier {
                shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundalID)
            }
            shareLink.iOSParameters?.appStoreID = "1440983596"
            shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.mtech.freshnaroma")
            
           
            
            shareLink.shorten { (url,warning, error) in
//                if let error = error {
//                   // print("Oh no! Got an error! \(error)")
//                }
//                if let warnings = warning {
//                    for warning in warnings {
//                       // print("FDL Warning: \(warning)")
//                    }
//                }
                
                guard let url = url else {
                     self.inviteMessage = "Use FRESH N AROMA for grocery purchase! use my code \(code) get a free ₹50 for registration. link - https://fna.page.link"
                    return }
                
                self.inviteMessage = "Use FRESH N AROMA for grocery purchase! use my code \(code) get a free ₹50 for registration. link - \(url.absoluteString)"
               // print("I have a short URL to share! \(url.absoluteString)")
                
                
                }
            }
            }
            
    
            
        
        
        
    
        
        // Do any additional setup after loading the view.
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    @IBAction func didPressedShareButton(_ sender: Any) {
        //let shareLike = "FreshNAroma"
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
             let shareLike = "\(inviteMessage)"
            controller.body = shareLike
            self.present(controller, animated: true, completion: nil)
        }
    }
    
   
    @IBAction func didPressedSocialShareButton(_ sender: Any) {
       
        let appLinnk = "\(inviteMessage)"
        let vc = UIActivityViewController(activityItems: [appLinnk], applicationActivities: [])
        present(vc, animated: true)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
  
}
