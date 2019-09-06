//
//  OrderdItemViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 15/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage
import Alamofire
class OrderdItemViewController: UIViewController, NVActivityIndicatorViewable ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var tableview: UITableView!{
        didSet{
            tableview.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var lblMRP: UILabel!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    
    @IBOutlet weak var lblTotalDiscount: UILabel!
    var basketTableData = [ViewbillProduct]()
    @IBOutlet weak var lblNetAmount: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let billNo = UserDefaults.standard.value(forKey: "bill_no")
        getviewOrders(invoiceNumber: billNo as! String)
        api.delegate = self
       
    }
    func getviewOrders(invoiceNumber: String){
       
            startAnimating()
            
            
            let dictionary = ["ViewBill":["invoiceno":"\(invoiceNumber)"]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : ViewbillRootClass, error) in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response![0].response_code == "1"{
                            
                            self.showViewOrder(responsValue)
                        }
                        
                        
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response![0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        
                        let alertVc = UIAlertController(title: "", message: Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
     
        
        
    }
    fileprivate func showViewOrder(_ responsValue: ViewbillRootClass) {
        
        
        self.basketTableData = responsValue.BillInfo!.Products!
        self.tableview.reloadData()
      /* // self.lblNavigationTitle.text =  "Order #\( responsValue.BillInfo!.Invoice!.Number!)"
       // self.lblName.text = responsValue.BillInfo!.Customer?.Name
       // self.lblContactnumber.text = responsValue.BillInfo!.Customer?.Mobile
        let date = responsValue.BillInfo!.Invoice!.Date
        var dateArray = date?.components(separatedBy: " ")
        let stringData = dateArray![0]
       // self.lblDate.text = stringData.reversed() as? String
        let stringdelveryCharge = responsValue.BillInfo!.Payment!.DeliveryCharge!
        
        self.lblPaymentType.text = ": \(responsValue.BillInfo!.Payment!.PaymentType!)"
//        if stringdelveryCharge == "0"{
//            self.lblDeliveryCharge.text = ": Free"
//            //self.lblDeliveryCharge.textColor = UIColor.green
//        } else {
//            self.lblDeliveryCharge.text = ": \(RupeeSymbol)\(responsValue.BillInfo!.Payment!.DeliveryCharge!)"
//        }
        
        
        if floatFromString(stringValue:  responsValue.BillInfo!.Payment!.Discount!) != 0 {
            self.lblMRP.text =  ": \(RupeeSymbol)\(responsValue.BillInfo!.Payment!.TotalAmount!)"
            self.lblTotalDiscount.text = ": \(RupeeSymbol)\(responsValue.BillInfo!.Payment!.Discount!)"
        }else {
            self.view2.isHidden = true
            self.view3.isHidden = true
            constraintMRP.constant = 0
            constraintDiscount.constant = 0
        }
        
        self.lblNetAmount.text = ": \(RupeeSymbol)\(responsValue.BillInfo!.Payment!.NetAmount!)"
        self.lblOrderTotal.text = ": \(RupeeSymbol)\(String(describing: responsValue.BillInfo!.Payment!.GrantTotal!))"
        
        let billingAddress = "\(responsValue.BillInfo!.Customer?.Billing!.Address1! ?? ""),\(responsValue.BillInfo!.Customer!.Billing!.Address2!),\(responsValue.BillInfo!.Customer?.Billing!.City! ?? ""),\(responsValue.BillInfo!.Customer!.Billing!.State!),\(String(describing: responsValue.BillInfo!.Customer!.Billing!.Pincode!))"
        
        let deliveryAddress = "\(responsValue.BillInfo!.Customer?.Delivery!.Address1! ?? ""),\(responsValue.BillInfo!.Customer?.Delivery!.Address2! ?? ""),\(responsValue.BillInfo!.Customer!.Delivery!.City! ),\(responsValue.BillInfo!.Customer!.Delivery!.State!),\(responsValue.BillInfo!.Customer!.Delivery!.Pincode!)" */
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OrderdItemViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketTableData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell") as! HotOffersTableViewCell
        //   cell.cellDelegate = self
        
        let  item = basketTableData[indexPath.row]
        cell.itemName?.text =  item.Name
        let imageString = item.ProductImage
        
        
        let   urlStr = imageString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.itemImage.af_setImage(withURL: URL(string: urlStr!)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size:cell.itemImage.frame.size))
        
        let stingQty = item.Quantity
        let qty:Int? = intFromString(stringValue: stingQty ?? "1")
        
        var price = doubleFromString(stringValue: item.SellingPrice!)
        cell.itemDiscription.text = "\(qty! ) X \(RupeeSymbol)\(price)"
        let mrp : Double = Double(item.MRP!)!
        
        if(price < mrp) {
            cell.itemPrice.text = String("MRP:\(RupeeSymbol)\(mrp)")
            let attributedString = NSMutableAttributedString(string: cell.itemPrice.text!)
            // Swift 4.2 and above
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.itemPrice.attributedText = attributedString
        }else {
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
        cell.itemTotal.text = String("Total:\(RupeeSymbol)\(price)")
        
        //  cell.setQuantityValue(value: qty! )
        
        
        return cell
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
    
    
}
