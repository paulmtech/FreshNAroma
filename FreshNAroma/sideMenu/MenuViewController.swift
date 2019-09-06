//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit
import SideMenuSwift

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}
var userInfo = UserInformationDefaultKey()

//var userDefaulUserInfo = UserDefaults.standard.value(forKey: UserDefaulKey.userData) as! [String : String]
class MenuViewController: UIViewController {
    var isDarkModeEnabled = false
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var lblUserName: UILabel!

    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    private var themeColor = UIColor.white
    var tableViewFirstSessionData = [[String : Any]]()
    var tableViewSecondSessionData = [String]()
    var code = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
tableViewFirstSessionData = [["title" : "Home" , "image" : "s_homeicon"],["title" : "Profile" , "image" : "user"],["title" : "My Orders" , "image" : "s_profileicon"],["title" : "Categories" , "image" : "s_category"],["title" : "Offers" , "image" : "s_offers"],["title" : "Notification" , "image" : "s_notification"],["title" : "Login" , "image" : "s_login"]]
        
//tableViewSecondSessionData  = ["Invite Friend","About US","Change Mentor","Followers","FAQ","Franchise","Contact Us","Privacy Policy" ]
        tableViewSecondSessionData  = ["Invite Friends","About US","Change Mentor","Followers","Franchise",/*"Contact Us",*/"Privacy Policy" ]
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()
        
        let viewControllerList = ["Home","Profile","MyOrder","Categories","Offers","FreshCash","notification","Login"]
        for i in 0...viewControllerList.count {
            let  tag = "0"+String(i)
            
            sideMenuController?.cache(viewControllerGenerator: {
                self.storyboard?.instantiateViewController(withIdentifier: viewControllerList[i])
            }, with: tag)
        }
        let viewControllerListSecondSession = ["InviteFriend","AboutUs","changmentor","followers","franchise",/*"contactus",*/"privacypolicy"]
        //let viewControllerListSecondSession = ["InviteFriend","AboutUs","changmentor","followers","Faq","franchise","contactus","privacypolicy"]
            for i in 0...viewControllerListSecondSession.count {
                let  tag = "1"+String(i)
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: viewControllerListSecondSession[i])
                }, with: tag)
            }
        

        sideMenuController?.delegate = self
    }
    func setTableTata()
    {
        
    }
    func removeUserDefaults (){
    let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSideMenu()
        
    }
    
    func setSideMenu() {
        
        
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            code = (userCode![UserDefaulKey.code]! as? String)!
            let firstname = userCode![UserDefaulKey.first_name]! as? String
            let lastname = userCode![UserDefaulKey.last_name]! as? String
            lblUserName.isHidden = false
            lblUserName.text = "\(firstname ?? "") \(lastname ?? "")"
            tableViewFirstSessionData = [["title" : "Home" , "image" : "s_homeicon"],["title" : "Profile" , "image" : "user"],["title" : "My Orders" , "image" : "s_profileicon"],["title" : "Categories" , "image" : "s_category"],["title" : "Offers" , "image" : "s_offers"],["title" : "Wallet" , "image" : "s_wallet"],["title" : "Notification" , "image" : "s_notification"],["title" : "Logout" , "image" : "s_logout"]]
            
          //  tableViewFirstSessionData = [["title" : "Home" , "image" : "s_homeicon"],["title" : "Profile" , "image" : "user"],["title" : "My Orders" , "image" : "s_profileicon"],["title" : "Categories" , "image" : "s_category"],["title" : "Offers" , "image" : "s_offers"],["title" : "Logout" , "image" : "s_logout"],["title" : "Notification" , "image" : "s_notification"]]
        }else{
            lblUserName.text = ""
            lblUserName.isHidden = true
            code = ""
          tableViewFirstSessionData = [["title" : "Home" , "image" : "s_homeicon"],["title" : "Profile" , "image" : "user"],["title" : "My Orders" , "image" : "s_profileicon"],["title" : "Categories" , "image" : "s_category"],["title" : "Offers" , "image" : "s_offers"],["title" : "Wallet" , "image" : "s_wallet"],["title" : "Notification" , "image" : "s_notification"],["title" : "Login" , "image" : "s_login"]]

        }
        
        tableView.reloadData()
    }
    
    private func configureView() {
        if isDarkModeEnabled {
            themeColor = UIColor(red: 0.03, green: 0.04, blue: 0.07, alpha: 1.00)
            //selectionTableViewHeader.textColor = .white
        } else {
            selectionMenuTrailingConstraint.constant = 0
            themeColor = UIColor(red: 0.98, green: 0.97, blue: 0.96, alpha: 1.00)
        }

        let showPlaceTableOnLeft = (SideMenuController.preferences.basic.position == .under) != (SideMenuController.preferences.basic.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
        }

        view.backgroundColor = themeColor
        tableView.backgroundColor = themeColor
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let showPlaceTableOnLeft = (SideMenuController.preferences.basic.position == .under) != (SideMenuController.preferences.basic.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, animationControllerFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

//    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
//
//    }
//
//    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
//       
//    }

//    func sideMenuWillHide(_ sideMenu: SideMenuController) {
//      //  print("[Example] Menu will hide")
//    }
//
//    func sideMenuDidHide(_ sideMenu: SideMenuController) {
//       // print("[Example] Menu did hide.")
//    }
//
//    func sideMenuWillReveal(_ sideMenu: SideMenuController) {
//       // print("[Example] Menu will show.")
//    }
//
//    func sideMenuDidReveal(_ sideMenu: SideMenuController) {
//       // print("[Example] Menu did show.")
//    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? tableViewFirstSessionData.count : tableViewSecondSessionData.count
       // return tableViewFirstSessionData.count
    }
    
    // swiftlint:disable force_cast
    func setCornerRadius(view: UIView) -> UIView {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        cell.contentView.backgroundColor = UIColor.white
        let  cellData = tableViewFirstSessionData[indexPath.row]
        cell.titleLabel?.text = cellData["title"] as? String
        cell.imageForSidemenu.image = UIImage(named: cellData["image"]! as! String)
        cell.titleLabel?.textColor = isDarkModeEnabled ? .white : .black
        return cell
        }
       else if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! SelectionCell2
        cell.titleLabel?.text = tableViewSecondSessionData[indexPath.row]
        cell.titleLabel?.textColor = isDarkModeEnabled ? .white : .black
        cell.contentView.backgroundColor =  UIColor.white
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var selectedMenu = String()
        if indexPath.section == 0{
           let cellData = tableViewFirstSessionData[indexPath.row]
            selectedMenu = (cellData["title"] as? String)!
        }else if indexPath.section == 1 {
          //let   cellData = tableViewSecondSessionData[indexPath.row]
             selectedMenu = tableViewSecondSessionData[indexPath.row]
        }
        
       // print(selectedMenu as! String)
        if(selectedMenu == "Logout" || selectedMenu == "Login") {
            if code.count > 0 {
                let alert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        do {
                            print(UserDefaults.standard.value(forKey: UserDefaulKey.userdict) as Any)
                            self.lblUserName.text = ""
                            UserDefaults.standard.removeObject(forKey: UserDefaulKey.userdict);
                            self.setSideMenu();
                            self.tableView.reloadData()
                            print(UserDefaults.standard.value(forKey: UserDefaulKey.userdict) as Any)
                            
                            //UserDefaults.standard.bool(forKey: UserDefaulKey.login)
                        }
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                } else {
                sideMenuController?.hideMenu()
                
                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.present(nextViewControler, animated: true, completion: nil)
            
            }
        }else{
        let row = indexPath.row
        let section = indexPath.section
        let tag = "\(section)"+"\(row)"
        if code.count > 0 {
            
            sideMenuController?.setContentViewController(with: "\(tag)", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
           
      //  print("[Example] View Controller Cache Identifier: " + sideMenuController!.currentCacheIdentifier()!)
        } else {
            
            if selectedMenu == "My Orders" || selectedMenu == "Profile" ||  selectedMenu == "Change Mentor" || selectedMenu == "Followers" || selectedMenu == "Wallet" || selectedMenu == "Notification" || selectedMenu == "Invite Friends" {
                let alertVc = UIAlertController(title: "", message: CommonString.alertMessageContinuetologin.rawValue, preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                    
                    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                    self.present(nextViewControler, animated: true, completion: nil)
                }))
                
                alertVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                self.present(alertVc, animated: true, completion: nil)
            }else {
                sideMenuController?.setContentViewController(with: "\(tag)", animated: Preferences.shared.enableTransitionAnimation)
                sideMenuController?.hideMenu()
            }
            
            
            }
    }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return ""
        case 1:
            return "Other"
        default:
            return "Other"
        }
    }
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var imageForSidemenu: UIImageView!
}
class SelectionCell2: UITableViewCell {
     @IBOutlet weak var titleLabel: UILabel!
}
