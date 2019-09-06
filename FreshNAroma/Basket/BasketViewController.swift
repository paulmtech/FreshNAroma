//
//  BasketViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 11/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import NVActivityIndicatorView

var orderTotal = String()
var savedAmount = String()
var pid = [String]()
var pqty = [String]()


public struct BasketDataRootClass : Decodable{
    
    public var cartinfo : BasketDataCartinfo!
    public var Response : [BasketDataResponse]!
    public var Results : [BasketDataResult]!
    public var Billinfo : [BasketDataCartinfoBillinfo]!
    
}
public struct BasketDataCartinfoBillinfo : Decodable {
    
    public var Netamount : String!
    public var Totalamount : String!
    public var Totaldiscount : String!
    
}
public struct BasketDataResponse : Decodable{
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct BasketDataResult : Decodable{
    public var id: String!
    public var  hsn_code: String!
    public var pdt_code: String!
    public var category:String!
    public var sub_category: String!
    public var pdt_name: String!
    public var pdt_name_tamil: String!
    public var pdt_description: String!
    public var pdt_unit: String!
    public var pdt_type: String!
    public var pdt_barcode: String!
    public var pdt_price: String!
    public var selling_price: String!
    public var mrp: String!
    public var disc: String!
    public var cgst: String!
    public var  sgst: String!
    public var  available: String!
    public var  batch: String!
    public var  profile_picture: String!
    public var  gst_slab: String!
    public var cmp_commission: String!
    public var selling_percent: String!
    public var warehouse_percent: String!
    public var unit_percent: String!
    public var unit_sales_price: String!
    public var wh_sales_price: String!
    public var status: String!
    public var visible: String!
    public var barcode_status: String!
    public var  approve_status: String!
    public var updated_date: String!
    public var updated_by: String!
    public var updated_ip: String!
    public var productid: String!
    public var cartqty: String!
    public var productimage: String!
}
public struct BasketDataCartinfo : Decodable{
    
    public var cartcount : Int!
    
}






class BasketViewController: UIViewController,SubMenuListDelegate,NVActivityIndicatorViewable ,UITextFieldDelegate,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var emptyBasketView: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    var basketTableDate = [BasketDataResult]()
   
    @IBOutlet weak var tableview: UITableView!{
        didSet{
            tableview.tableFooterView = UIView()
        }
    }
   
    public  func getUserCode() -> String{
        var  userID = ""
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            userID =  (userCode![UserDefaulKey.code]! as? String)!
        }
        return userID
    }
    
   
    @IBOutlet weak var btnDelete: UIButton!
    func didAddButtonTapped(btn: UIButton) {
        let index = btn.tag
        let cellData = basketTableDate[index]
        let dictionary = ["AddtoCart":["id" :cellData.id!,"sessionid":sessionId!,"quantity":"1","code": getUserCode()]]
        
        api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : addcartRootClass, error) in
       if case .success = error {
                let responsValue = result
                if responsValue.Response[0].response_code == "0"{
                     DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    }
                }
//                else if responsValue.Response[0].response_code == "1"{
//                    DispatchQueue.main.async {
//                        self.getCartFromApi()
//                        }
//                    }
//                }
            }
            if case .success = error {
                
                DispatchQueue.main.async {
                   self.getCartFromApi()
                   }
            }
        }

    }
    
    func didMinusButtonTapped(btn: UIButton) {
        let index1 = btn.tag
        let cellData = basketTableDate[index1]
        let qty = getMQty(qty: cellData.cartqty)
        if qty == "0" {
            let dictionary = ["RemoveCart": ["id" : cellData.id, "sessionid":sessionId!]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]) { (result : addcartRootClass, error) in
                if case .success = error {
                    
                    self.getCartFromApi()
                   
                }
            }
        }else {
            let dictionary = ["UpdateCartQuantity":["id" : cellData.id!,"sessionid":sessionId!,"quantity":qty,"code": getUserCode()]]
            api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : addcartRootClass, error) in
            if case .success = error {
                DispatchQueue.main.async {
                    self.getCartFromApi()
                }
            }
        }
        }
    }
    
    
  
    //MARK:- View
    override func viewDidLoad() {
    super.viewDidLoad()
        api.delegate = self
        emptyBasketView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartFromApi()
       
    }
    func showTotal(billinfo: BasketDataCartinfoBillinfo ){
        
        var item = "item"
        if basketTableDate.count > 1{
            item = "items"
        }
        
        let totalSaved = floatFromString(stringValue: billinfo.Totaldiscount)
        
        var saved = ""
        if totalSaved > 0 {
            saved = String(format: "\nSaved ₹%.2f", totalSaved)
            savedAmount = String(format: "%.2f", totalSaved)
        }else {
            savedAmount = ""
        }
          orderTotal = billinfo.Netamount
          lblTotal.text = String(format: "\(basketTableDate.count) \(item) | ₹%@\(saved)",billinfo.Netamount)
        
        
    }
    
    func showTotal(){
        let priceListItems =  basketTableDate
        
        var total = Double()
        var savedTotal = Double()
        var am = Double()
        var por_mrp = Double()
        var qtyV =  Double()
        for item in priceListItems
        {
            if let amount = item.selling_price {
               am = Double(amount)!
            }
            if  let qty = item.cartqty{
                qtyV = Double(qty)!
            }
            if let mrp = item.mrp{
                por_mrp = Double(mrp)!
            }
            total += am * qtyV
            savedTotal += qtyV * (por_mrp - am)
        }
        var item = "item"
        if basketTableDate.count > 1{
          item = "items"
        }
        savedAmount = String(format: "%.2f", savedTotal)
        var saved = ""
        if savedTotal > 0 {
            saved = String(format: "\nSaved ₹%.2f", savedTotal)
        }
        
        orderTotal = String(format: "%.2f", total)
        //savedAmount = "\(savedAmount)"
        
       // lblTotal.text =  "\(basketTableDate.count) \(item) | ₹\(total)\(savedAmount)"
        lblTotal.text = String(format: "\(basketTableDate.count) \(item) | ₹%.2f\(saved)",total)
    }
    
    func showEmptyView()  {
        
        if basketTableDate.count > 0 {
            btnDelete.isHidden = false
            emptyBasketView.isHidden = true
        } else {
            btnDelete.isHidden = true
            emptyBasketView.isHidden = false
        }
        
    }
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    
        


   
    @IBAction func didPressedStartShopping(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func getProductIdandQty() {
        pid.removeAll()
        pqty.removeAll()
        for item in basketTableDate {
                let id = item.id!
                let qty = item.cartqty!
            pid.append(id)
            pqty.append(qty)
            
            
            }
      
      
    }
    @IBAction func didPressedCheckOut(_ sender: Any) {
        
        getProductIdandQty()
       let code = getSavedCustomerCode()
       if code != ""{
        
            let storyBoardId =  "checkoutpage"
            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as? CheckoutPageViewController
        
        let dict = ["total" : orderTotal,"saved": savedAmount,"pid":pid,"qty":pqty] as [String : Any]
        nextViewControler?.dictPament = dict
            self.navigationController?.pushViewController(nextViewControler!, animated: true)
           }else {
        let alertVc = UIAlertController(title: "", message: CommonString.alertMessageContinuetologin.rawValue, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
              
                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.present(nextViewControler, animated: true, completion: nil)
            }))
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alertVc.addAction(cancelAction)
            self.present(alertVc, animated: true, completion: nil)
            
            
            
            
            
        }
      
        }
    
    @IBAction func didPressedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showGetUserName() {
        
        let alertController = UIAlertController(title: "FreshN Aroma", message: "Already registered?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            alert -> Void in
            let phonenumber = alertController.textFields![0] as UITextField
           phonenumber.keyboardType = .numberPad
    
            if phonenumber.text != ""{
              //  self.newUser = User(fn: fNameField.text!, ln: lNameField.text!)
                //TODO: Save user data in persistent storage - a tutorial for another time
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Plese enter valide number.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel
            , handler: nil))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter Phonenumber"
            textField.textAlignment = .center
        })
        
        alertController.addAction(UIAlertAction(title: "Register to Create an Account", style: .default, handler: { action in
           
            
            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            nextViewControler?.viewPresentType = "Present"
            self.present(nextViewControler!, animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    func getCartFromApi(){
       
            startAnimating()
            let dictionary = ["CartMenu": ["sessionid": sessionId]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]){ (result : BasketDataRootClass, error)  in
                DispatchQueue.main.async {
                self.stopAnimating()
            }
            if case .success = error {
                let responsValue = result
                if responsValue.Response[0].response_code == "1"{
                    self.basketTableDate = responsValue.Results
                    DispatchQueue.main.async {
                        self.showTotal(billinfo: responsValue.Billinfo[0])
                        self.showEmptyView()
                        self.tableview.reloadData()
                        BasketData.badge = Int(responsValue.cartinfo.cartcount)
                        
                        
                    }
                } else if responsValue.Response[0].response_code == "0"{
                    let alert = UIAlertController(title: "FreshNAroma", message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            if case .failure = error{
                let alert = UIAlertController(title: "FreshNAroma", message: Constants.ALERT_SERVER_ERROR, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
   
    
    
    @IBAction func didPressedEmptyCart(_ sender: Any) {
        let alertVc = UIAlertController(title: "", message: CommonString.alertMessageEmptyCart.rawValue, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            self.startAnimating()
            let dictionary = ["EmptyCart":["sessionid":sessionId!]]
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : addcartRootClass, error) in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                }
                if case .success = error {
                    BasketData.badge = 0
                    
                    DispatchQueue.main.async {
                        self.getCartFromApi()
                    }
                    
                    
                }
            }
        }))
        
        alertVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(alertVc, animated: true, completion: nil)

        
    }
}

extension BasketViewController:UITableViewDataSource,UITableViewDelegate{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketTableDate.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell") as! HotOffersTableViewCell
        cell.cellDelegate = self
        cell.viewQuantity.tag = (indexPath.section * 10000)  + (indexPath.row )
        cell.viewQuantity.addButton.tag = cell.viewQuantity.tag
        cell.viewQuantity.plusButton.tag = cell.viewQuantity.tag
        cell.viewQuantity.minusButton.tag = cell.viewQuantity.tag
        let  item = basketTableDate[indexPath.row]
        cell.itemName?.text =  item.pdt_name
        let imageString = item.productimage
        let   urlStr = imageString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        cell.itemImage.af_setImage(withURL: URL(string: urlStr!)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size:cell.itemImage.frame.size))
        
        
        let stingQty = item.cartqty
        var price = doubleFromString(stringValue: item.selling_price)
        cell.itemDiscription.text = String(format: "\(RupeeSymbol)%.2f",price)
        let mrp : Double = Double(item.mrp )!
      
        let qty:Int? = intFromString(stringValue: stingQty!)
        
        if(price < mrp) {
             cell.itemPrice.text = String(format: "MRP:\(RupeeSymbol)%.2f",mrp)
            let attributedString = NSMutableAttributedString(string: cell.itemPrice.text!)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.itemPrice.attributedText = attributedString
        }
       else {
//            if qty == 1{
//                cell.itemDiscription.isHidden = true
//                cell.itemPriceTagImage.isHidden = true
//            }else {
//                cell.itemDiscription.isHidden = false
//                cell.itemPriceTagImage.isHidden = false
//            }
           cell.itemPrice .isHidden = true
        }
        
        
        
       
       
        price = price * Double(qty!)
        cell.itemTotal.text = String(format: "Total:\(RupeeSymbol)%.2f",price)
       
        cell.setQuantityValue(value: qty! )
        
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath)
        let kCellActionWidth = CGFloat(70.0)// The width you want of delete button
        //let kCellHeight = tableView.frame.size.height // The height you want of delete button
        let whitespace = whitespaceString(width: kCellActionWidth) // add the padding
        
        
        let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) {_,_ in
            let  item = self.basketTableDate[indexPath.row]
            let dictionary = ["RemoveCart": ["id" : item.id, "sessionid":sessionId!]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]) { (result : addcartRootClass, error) in
                if case .success = error {
                    BasketData.badge = 0
                   
                    self.getCartFromApi()

                   
                }
            }
        }
        
        // create a color from patter image and set the color as a background color of action
        let view = UIView(frame: (cell?.frame)!)
        //view.backgroundColor =  UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1.0)
        view.backgroundColor =  UIColor.red
        let imageView = UIImageView(frame: CGRect(x: 20,
                                                  y: (cell?.frame.size.height)!/3,
                                                  width: 40,
                                                  height: 40))
        imageView.image = UIImage(named: "delete")! // required image
        
        view.addSubview(imageView)
        let image = view.image()
        
        deleteAction.backgroundColor = UIColor.init(patternImage: image)
        return [deleteAction]
        
    }
    

    
    
    @IBAction func didPressedBackToHome(_ sender: Any) {
      self.navigationController?.popToRootViewController(animated: true)
//        let viewController = HomeViewController()
//        self.navigationController?.popToViewController(viewController, animated: false)
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeViewController.self) {
//                _ =  self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
}
    
    //MARK: - Delete Function
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSAttributedStringKey.font: font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
   
//    // Override to support editing the table view.
//    - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//    //add code here for when you hit delete
//    }
//    }
}
