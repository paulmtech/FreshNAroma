//
//  NoNetWorkViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 23/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NoNetWorkViewController: UIViewController,NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressedRetry(_ sender: Any) {
        startAnimating()
        if  Connectivityy.isConnectedToInternet{
            stopAnimating()
            dismiss(animated: false, completion: nil)
        }
        perform(#selector(stopViewAnimation), with: nil, afterDelay: 1)
        
    }
   
    @objc func stopViewAnimation(){
       stopAnimating()
    }
}
