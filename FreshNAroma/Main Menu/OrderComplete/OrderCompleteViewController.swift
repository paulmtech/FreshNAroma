//
//  OrderCompleteViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 17/10/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class OrderCompleteViewController: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // imageview.contentScaleFactor = 2.0
        UIView.animate(withDuration: 0, animations: {() -> Void in
            self.imageview?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 1, animations: {() -> Void in
                self.imageview?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        })
    }
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        
        self.sideMenuController?.revealMenu()
        
    }

    @IBAction func didPressedOkButton(_ sender: Any) {
        BasketData.badge = 0
        navigationController?.popToRootViewController(animated: false)
        
    }
    

}
