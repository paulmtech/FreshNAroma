//
//  RootViewController.swift
//  FreshNAroma
//
//  Created by Paul 04/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class RootViewController: UIViewController,NVActivityIndicatorViewable {
 @IBOutlet weak var lblNavigationTitle: UILabel!
 @IBOutlet weak var btnBasket: FNBadgeButton!
 @IBOutlet weak var NavigationView: UIView!
    

    
    @IBOutlet weak var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

     //  btnBasket.badge = String(BasketData.badge)
      
}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       /// btnBasket.badge = String(BasketData.badge)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       //
//        let notificationButton = FNBadgeButton()
//        notificationButton.frame = btnBasket.frame
//        notificationButton.setImage(UIImage(named: "m_basket")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 15)
//        notificationButton.badge = "140"
//        NavigationView.addSubview(notificationButton)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        if sender.tag == 2001 {
            dismiss(animated: true, completion: nil)
        } else {
        self.sideMenuController?.revealMenu()
        }
    }
    @IBAction func didPressedBasketButton(_ sender: Any) {
    
        if BasketData.badge > 0{
      
        let storyBoardId =  "BasketViewController"
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId)
            self.navigationController?.pushViewController(nextViewControler, animated: true)
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please select Items", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
  @IBAction func didPressedBackButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    stopAnimating()
    }

}
