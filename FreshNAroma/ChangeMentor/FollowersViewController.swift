//
//  FollowersViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 21/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class FollowersViewController: RootViewController  ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var lblSecondline: UILabel!
    @IBOutlet weak var lblFirstline: UILabel!
    @IBOutlet weak var lblSecondLineFollowers: UILabel!
    @IBOutlet weak var lblFirstLineFollowers: UILabel!
    //@IBOutlet weak var tableView: UITableView!
        override func viewDidLoad() {
        super.viewDidLoad()
            api.delegate = self
            let code = getSavedCustomerCode()
            if code != ""{
            
                getFollowers(customerCode: code)
            }else {
                let alertVc = UIAlertController(title: "", message:"Please login", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                   
                    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                    self.present(nextViewControler, animated: true, completion: nil)
                }))
                self.present(alertVc, animated: true, completion: nil)
            }
            lblFirstLineFollowers.layer.borderColor = UIColor.black.cgColor
            lblFirstLineFollowers.layer.borderWidth = 1
            
            lblSecondLineFollowers.layer.borderColor = UIColor.black.cgColor
            lblSecondLineFollowers.layer.borderWidth = 1
            
            lblFirstline.layer.borderColor = UIColor.black.cgColor
            lblFirstline.layer.borderWidth = 1
            
            lblSecondline.layer.borderColor = UIColor.black.cgColor
            lblSecondline.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getFollowers(customerCode: String){
       
            startAnimating()
             let dictionary = ["Followers":["customer":customerCode]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : followersRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            self.lblFirstLineFollowers.text = responsValue.Followers.FirstLevel
                            self.lblSecondLineFollowers.text = responsValue.Followers.SecondLevel

                            
                        } else if responsValue.Response[0].response_code == "0"{
                            let msg = responsValue.Response[0].response_msg
                            
                            let alertVc = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
                        }
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                    let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let alertVc = UIAlertController(title: "", message:result.Response[0].response_msg , preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
       
        
        
    }
}

public struct followersRootClass : Decodable {
    
    public var Followers : followersFollower!
    public var Response : [followersResponse]!
    
}
public struct followersResponse  : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct followersFollower : Decodable {
    
    public var FirstLevel : String!
    public var SecondLevel : String!
    
}
