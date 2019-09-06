//
//  NotificationViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 03/11/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class NotificationViewController: RootViewController ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    var tableDate = [NotificationResult]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 130
        tableview.tableFooterView = UIView()
        api.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotification()
    }

    func loadNotification(){
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        if userCode != nil {
        let  customerCode =  (userCode![UserDefaulKey.code]! as! String)
        let api = APIRequestFetcher()
        let dictionary = ["Notification":["code": customerCode]]
        
        api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : NotificationRootClass , errorType) in
                if case .success = errorType {
                    DispatchQueue.main.async {
                        let responsValue = result
                       if responsValue.Response[0].response_code == "1"{
                        self.tableDate = responsValue.Results!
                        self.tableview.tableFooterView = UIView()
                        self.tableview.reloadData()
                        }
                       else if responsValue.Response[0].response_code == "0"{
                        self.tableview.reloadData()
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableview.frame.width, height: 21))
                        label.center = CGPoint(x: 160, y: 284)
                        label.textAlignment = NSTextAlignment.center
                        label.text = "\(responsValue.Response[0].response_msg ?? "No recordsfound.")"
                        label.center = self.tableview.center
                        self.tableview.tableFooterView = label
                        }

                        
                        
                    }
                } else if case .failure = errorType {
                    
                }
            }
           
        }
        }
    

}

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchProductTableViewCell
        
        cell.lblTitle.text = tableDate[indexPath.row].title
        cell.lblDiscription.text = tableDate[indexPath.row].description 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}




public struct NotificationRootClass : Decodable {
    
    public var Response : [NotificationResponse]!
    public var Results : [NotificationResult]!
    
}
public struct NotificationResult : Decodable {
    
    public var attachments : String!
    public var created_by : String!
    public var created_date : String!
    public var created_ip : String!
    public var customer_code : String!
    public var deleted_status : String!
    public var description : String!
    public var id : String!
    public var message_type : String!
    public var title : String!
    
}
public struct NotificationResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
