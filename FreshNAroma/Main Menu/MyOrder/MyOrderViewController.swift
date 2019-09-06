//
//  MyOrderViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 11/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

import NVActivityIndicatorView
class MyOrderViewController: UIViewController, NVActivityIndicatorViewable ,ApiErrorResponsDelegate, loadStareDelegate {
    func showStareRatingView() {
        getMyorders()
    }
    
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    
    
    var arryMyOrders = [MyOrderBillInfo]()
    @IBOutlet weak var tableView: UITableView! {didSet{
    tableView.tableFooterView = UIView(frame: CGRect.zero)
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.addSubview(self.refreshControl)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        api.delegate = self
        
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getMyorders()
        showNoRecordFount()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MyOrderViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    override func viewWillAppear(_ animated: Bool) {
        getMyorders()
    }
    func getMyorders(){
        
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            let code = (userCode![UserDefaulKey.code]! as? String)!
            getOrders(customerid: code)
            
        }else {
             refreshControl.endRefreshing()
            let alertVc = UIAlertController(title: "", message: CommonString.alertMessageContinuetologin.rawValue, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                
                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.present(nextViewControler, animated: true, completion: nil)
            }))
            
            alertVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                DispatchQueue.main.async {

                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: HomeViewController.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }))
            self.present(alertVc, animated: true, completion: nil)
            
           
        }
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        
        self.sideMenuController?.revealMenu()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MyOrderViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryMyOrders.count
    }
    func getQty(qty : String) -> String{
      
        let qtyArray = qty.split(separator: ",")
        return "\(qtyArray.count)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arryMyOrders[indexPath.row].delivery_status == "4" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myorderrate") as! MyOrderWithRateTableViewCell
            
      
        cell.cellDelegate = self
        cell.btnOrderDeataile.tag = indexPath.row
        cell.btnTrackOrder.tag = indexPath.row
        cell.btnShowRateView.tag = indexPath.row
        
        
        let qty = getQty(qty: "\(arryMyOrders[indexPath.row].qty!)")
        
        let items = "Items: \(qty)"
       
        let myRange = NSRange(location: 0, length: 6)
        let anotherAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.gray ,NSAttributedString.Key.font: UIFont(name: "Helvetica neue", size: 18.0)!]
         let myString = NSMutableAttributedString(string: items)
        
        myString.addAttributes(anotherAttribute, range: myRange)
       // cell.lblItem.attributedText = myString
        cell.lblItem.text = items
        
        let amount = arryMyOrders[indexPath.row].net_amt
        let deliverycharge = arryMyOrders[indexPath.row].delivery_charge
        
        let price = floatFromString(stringValue: amount!) + floatFromString(stringValue: deliverycharge!)
        cell.lblDate.text =  "Billed Date: \( getDateFromString(dateStr: arryMyOrders[indexPath.row].created_date!))"
        cell.lblTotal.text = "Total: \(RupeeSymbol)\(price)"
       
        cell.lblPaymentType.text = "\(arryMyOrders[indexPath.row].payment_type!)"
        let Orderid = "Order id:\(arryMyOrders[indexPath.row].bill_no!)"
        let aString = NSMutableAttributedString(string: Orderid)
        let myRange1 = NSRange(location: 0, length: 9)
        aString.addAttributes(anotherAttribute, range: myRange1)
        cell.lblOrderid.text = Orderid
        let stars = (Double(arryMyOrders[indexPath.row].rating!))!
        cell.lblOrderStatus.text = "Order Status: \(orderStatus(orderStatus: arryMyOrders[indexPath.row].delivery_status!) )"
            cell.rateView.rating = stars
      
        return cell
             }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myorder") as! MyOrderTableViewCell
            
            
            cell.cellDelegate = self
            cell.btnOrderDeataile.tag = indexPath.row
            cell.btnTrackOrder.tag = indexPath.row
            
            
            let qty = getQty(qty: "\(arryMyOrders[indexPath.row].qty!)")
            
            let items = "Items: \(qty)"
            
            let myRange = NSRange(location: 0, length: 6)
            let anotherAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.gray ,NSAttributedString.Key.font: UIFont(name: "Helvetica neue", size: 18.0)!]
            let myString = NSMutableAttributedString(string: items)
            
            myString.addAttributes(anotherAttribute, range: myRange)
            // cell.lblItem.attributedText = myString
            cell.lblItem.text = items
            
            let amount = arryMyOrders[indexPath.row].net_amt
            let deliverycharge = arryMyOrders[indexPath.row].delivery_charge
            
            let price = floatFromString(stringValue: amount!) + floatFromString(stringValue: deliverycharge!)
            cell.lblDate.text =  "Billed Date: \( getDateFromString(dateStr: arryMyOrders[indexPath.row].created_date!))"
            cell.lblTotal.text = "Total: \(RupeeSymbol)\(price)"
            
            cell.lblPaymentType.text = "\(arryMyOrders[indexPath.row].payment_type!)"
            let Orderid = "Order id:\(arryMyOrders[indexPath.row].bill_no!)"
            let aString = NSMutableAttributedString(string: Orderid)
            let myRange1 = NSRange(location: 0, length: 9)
            aString.addAttributes(anotherAttribute, range: myRange1)
            cell.lblOrderid.text = Orderid
            cell.lblOrderStatus.text = "Order Status: \(orderStatus(orderStatus: arryMyOrders[indexPath.row].delivery_status!) )"
            
            
            return cell
    }
    }
    func orderStatus(orderStatus: String) -> String {
        
        switch orderStatus {
        case "0":
          return "Order Placed."
        case "1":
            return "Accepted."
        case "2":
            return "Packed."
        case "3":
            return "Out for Delivery."
        case "4":
            return "Delivered."
        default:
            return ""
        }
    
}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myorderheader") as! MyOrderHeaderTableViewCell
        cell.lblTitle.text = section == 0 ? "Current Order" : "Completed Order"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.estimatedRowHeight = 44.0 // standard tableViewCell height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "ViewOrderViewController") as? OrderSwipeNavigationViewController
       
       let invoiceNo = arryMyOrders[indexPath.row].bill_no
         UserDefaults.standard.set(invoiceNo, forKey: "bill_no")

        let itemView = ViewOrderViewController()
        itemView.invoiceno = invoiceNo!
        navigationController?.pushViewController(nextViewControler!, animated: true)
        //present(nextViewControler!, animated: true, completion: nil)
    }
    
    
    
    
}





 public struct MyOrderRootClass: Decodable {
    
    public var BillInfo : [MyOrderBillInfo]!
    public var Response : [MyOrderResponse]!
    
}
public struct MyOrderResponse: Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
//
//  MyOrderBillInfo.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 3, 2019

import Foundation

//MARK: - MyOrderBillInfo
public struct MyOrderBillInfo : Decodable {
    
    
    public var id: String!
    public var unit: String!
    public var bill_no: String!
    public var customer_id: String!
    public var cus_name: String!
    public var mobile: String!
    public var product_name: String!
    public var products: String!
    public var qty: String!
    public var amount: String!
    public var used_redeem_point: String!
    public var net_amt: String!
    public var bill_save: String!
    public var payment_type: String!
    public var transactionid: String!
    public var delivery_status:String!
    public var order_type: String!
    public var created_date: String!
    public var delivery_charge: String!
    public var rating: String?
    public var comments: String?
    
}

extension MyOrderViewController {
    func showNoRecordFount(){
        if arryMyOrders.count == 0{
            addNodataView()
        }else {
            removeNodataView()
        }
    }
    func addNodataView(){
        let cell = tableView.dequeueReusableCell(withIdentifier: "myorderheader") as! MyOrderHeaderTableViewCell
        cell.lblTitle.text = "No Data Fount"
        tableView.tableFooterView = cell
    }
    func removeNodataView(){
        tableView.tableFooterView  = UIView(frame: CGRect.zero );
        
    }
    func getOrders(customerid: String){
        
            startAnimating()
            let dictionary = ["MyOrders": ["customer": customerid]]
            
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : MyOrderRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            
                            self.arryMyOrders = responsValue.BillInfo
                            self.showNoRecordFount()
                            self.tableView.reloadData()
                            
                        }
                        else if responsValue.Response[0].response_code == "0" {
                            self.tableView.reloadData()
                            self.addNodataView()
                        }
                        
                        
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                       // let result = result["error"]
                        
                        let alertVc = UIAlertController(title: "", message: Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
     
        
       
    }
    
    
}

extension MyOrderViewController : MyOrderButtonDelegate{
    func didpressedViewOrderButton(_ tag: Int) {
       
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "ViewOrderViewController") as? ViewOrderViewController
        let invoiceNo = arryMyOrders[tag].bill_no
        nextViewControler?.invoiceno = invoiceNo!
        present(nextViewControler!, animated: true, completion: nil)
    }
    
    func didPressedOrderTrackButton(_ tag: Int) {
       
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController
        let invoiceNo = arryMyOrders[tag].bill_no
        nextViewControler?.invoiceno = invoiceNo!
        present(nextViewControler!, animated: true, completion: nil)
    }
    func didPressedRateUsButton(_ tag: Int) {
        
//        if let comments = arryMyOrders[tag].comments{
//            print("My daughters name is: \(comments)")
//        }
//
//        if let rate = arryMyOrders[tag].rating{
//            print("My daughters name is: \(rate)")
//        }
        
     showFeedBackView(billno:  arryMyOrders[tag].bill_no, text: arryMyOrders[tag].comments!,rate: arryMyOrders[tag].rating!)
    }
    
    func showFeedBackView(billno: String,text: String,rate: String){
        
        let storyBoardId =  "feedback"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! FeedBackViewController
        nextViewControler.billNo = billno
        nextViewControler.rating = rate
        nextViewControler.feedbackText = text
        nextViewControler.delegate = self
        nextViewControler.modalPresentationStyle = .overCurrentContext
       self.present(nextViewControler, animated: false, completion: nil)
        
    }
    
    
}
