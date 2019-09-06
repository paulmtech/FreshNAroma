//
//  OrderSwipeNavigationViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 15/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import CarbonKit

class OrderSwipeNavigationViewController: UIViewController,CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "orderinfoview")
        }
        return storyboard.instantiateViewController(withIdentifier: "itemview")
    }
    
    @IBOutlet weak var navigationTitle: UILabel!
    var bill_no = String()
    @IBOutlet weak var bgView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBOutlet weak var slideviewBG: UIView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    @IBAction func didPressedback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let items = ["SUMMARY", "ITEMS"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: bgView)
      

    }


}
