//
//  HotOfferDetailViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 07/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
import TransitionButton
class HotOfferDetailViewController: RootViewController,UICollectionViewDataSource,UICollectionViewDelegate,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
   // MARK: - properties
    
    @IBOutlet weak var btnAddToCart: TransitionButton!
    
   // var selectedItem = [OffersResult]()
    var productItems = [OffersResult]()
    var searchItemJson = [JSON]()
    //var offerSelectedItem = [OffersResult]()
    var isJson = Bool()
    var isOffer = Bool()
    var isProduct = Bool()
    var iteminfo = [String:String]()
    @IBOutlet weak var addView: QuantitySelectorView!
    @IBOutlet weak var moreProductbg: UIView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productMRP: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productAvailables: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productOffer: UILabel!
    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var productBgView: UIView!
    @IBOutlet weak var smallIconcollectionView: UICollectionView!
    var product_id = String()
    @IBOutlet weak var lblDiscount: UILabel!
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        moreProductbg.isHidden = true
        productOffer.layer.borderWidth = 2
        productOffer.layer.borderColor = UIColor.hexStringToUIColor(hex:ColorCode.green.rawValue, alphavalue: 1).cgColor
        productOffer.textColor = UIColor.hexStringToUIColor(hex:ColorCode.green.rawValue, alphavalue: 1)
        setAddViewProperties()
    
        if isJson{
           iteminfo = itemFromJsonObject(product: searchItemJson)
           productInfo(product: iteminfo)
            
        } else if isOffer {
            iteminfo = itemFromDecodeObjectOffer(product: productItems)
             moreProductbg.isHidden = true
             productInfo(product: iteminfo)
        } else if isProduct {
            api.delegate = self
            getProduct()
            
            
        }
            
        
        else {
            // Decodeable respons
             moreProductbg.isHidden = true
            iteminfo = itemFromDecodeObject(product: productItems)
            //productInfo(product: selectedItem)
        }
       
        productBgView.layer.borderWidth = 1
        productBgView.layer.cornerRadius = 25
        productBgView.layer.borderColor = UIColor.hexStringToUIColor(hex:ColorCode.yellow.rawValue, alphavalue: 1.0) .cgColor
        
       
        addtocartbutton()
    }
    func getProduct(){
        startAnimating()
        let dictionary = ["ViewProduct": ["id": product_id]]
        api.fetchApiResult(viewController: self, paramDict:dictionary) { (result: ViewProductRootClass, error) in
            DispatchQueue.main.async {
                self.stopAnimating()
                }
            if case .success = error {
                let responsValue = result
                
               if responsValue.Response[0].response_code == "1"{
                
                    DispatchQueue.main.async {
                        
                        self.iteminfo = itemFromViewProduct(product:responsValue.Results)
                        self.productInfo(product: self.iteminfo)
                    }
                }
            }
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
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation()
        self.view.isUserInteractionEnabled = false
        
        let dictionary = ["AddtoCart":["id" : product_id,"sessionid":sessionId!,"quantity":"1","code": getUserCode()]]
        
        api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : addcartRootClass, error) in
           button.stopAnimation()

            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
            }
            if case .success = error {
                let responsValue = result
                if responsValue.Response[0].response_code == "0"{
                     DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    }
                }
                else if responsValue.Response[0].response_code == "1"{
                    DispatchQueue.main.async {
                        BasketData.badge = Int(responsValue.Item)!
                        self.btnBasket.badge = String(BasketData.badge )
                        let alert = UIAlertController(title: "", message: "Item added", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    func addtocartbutton() {
        btnAddToCart.spinnerColor = .white
        btnAddToCart.cornerRadius = 5.00
        //cell.btnAddtoCart.tag = indexPath.row
        btnAddToCart.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
    }
    //MARK: - Json valaue
    func productInfo(product: [String:String]){
        
        
        product_id = ((product["id"]! as NSString) as String)
        let pdt_price =  (product["selling_price"]! as NSString).floatValue
        let mrp : Float = (product["mrp"]! as NSString ).floatValue
        productTitle.text = product["pdt_name"]!
        productPrice.text = String(format :"\(RupeeSymbol)%.2f",pdt_price)
        let urlStr : NSString = product["productimage"]!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        productImageview.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: productImageview.frame.size))
        productDescription.text = product["pdt_description"]!
        let discount = floatFromString(stringValue:product["disc"]!)
        if discount > 0 {
            lblDiscount.text = String(format: " You Save \(RupeeSymbol)%.2f ",discount)
            
            lblDiscount.isHidden = false;
            
            
        } else {
            lblDiscount.isHidden = true;
        }
        if(pdt_price < mrp) {
            productMRP.text = String(format:"MRP:\(RupeeSymbol)%.2f",mrp)
            let attributedString = NSMutableAttributedString(string: productMRP.text!)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            productMRP.attributedText = attributedString
        }else{
            productMRP.isHidden = true
        }
    }
     //MARK: - Json valaue
//    func productInfo(product: [SubcategoryProductsResult]){
//        let pdt_price = (product[0].selling_price! as NSString ).floatValue
//        let mrp : Float = (product[0].mrp! as NSString ).floatValue
//
//        productTitle.text = product[0].pdt_name
//        productPrice.text = String("\(RupeeSymbol)\(pdt_price)")
//        let urlStr : NSString = product[0].productimage!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
//        productImageview.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: productImageview.frame.size))
//        productDescription.text = product[0].pdt_description
//       if (pdt_price < mrp) {
//            productMRP.text = String("MRP:\(RupeeSymbol)\(product[0].mrp! )")
//            let attributedString = NSMutableAttributedString(string: productMRP.text!)
//            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
//            productMRP.attributedText = attributedString
//
//        }else{
//            productMRP.isHidden = true
//        }
//    }
    
    //MARK: -  CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == smallIconcollectionView {
            return productItems.count
        }
       return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == smallIconcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeSmallIconScrollCollectionViewCell
            cell.bgView.layer.cornerRadius = 5
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1.0) .cgColor
            let  cellData = productItems[indexPath.row]
            cell.lblTitle.text = cellData.pdt_name
            let imageString = cellData.productimage!
            //let imgURL = URL(string: imageString)
            let urlStr : NSString = imageString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
            cell.image.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: cell.image.frame.size))
            return cell
        }
        
       
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let  cellData = productItems[indexPath.row]
        setQuantityValue(value: 0)
      //  productInfo(product: [cellData])
    }
    
    //MARK: - CustomView
    func setAddViewProperties() {
        if addView != nil  && !addView.isPropertisSet {
            addView.quantityLabel.text = "0"
            addView.isPropertisSet = true
            addView.createControls()
            addView.addButton.addTarget(self, action: #selector(didPlusButtonTapped), for: .touchUpInside)
            addView.plusButton.addTarget(self, action: #selector(didPlusButtonTapped), for: .touchUpInside)
            addView.minusButton.addTarget(self, action: #selector(HotOffersTableViewCell.didMinusButtonTapped(btn:)), for: .touchUpInside)
        }
        
    }
    func setQuantityValue(value : Int) {
        addView.quantityLabel.text = "\(value)"
        if value > 0 {
            addQuantity()
            setAddViewWithQuantity()
        }
        else {
            setAddViewWithoutQuantity()
        }
    }
    func setMinusQuantityValue(value : Int) {
        addView.quantityLabel.text = "\(value)"
        let basketItems =  BasketData.userSelectedItems
        let id = iteminfo[ProductInfo.pdt_code.rawValue]
        let filteredArray = basketItems.filter({ $0["pdt_code"] == id  })
        
        var item = filteredArray[0]
        if value > 0 {
            if let index1 = BasketData.userSelectedItems.index(of: item) {
                item["qty"] = getMQty(qty: (item["qty"]!))
                BasketData.userSelectedItems[index1] = item
            }
            setAddViewWithQuantity()
            
        }
        else {
            if let index1 = BasketData.userSelectedItems.index(of: item) {
                BasketData.badge -= 1
                btnBasket.badge = String( BasketData.badge )
                BasketData.userSelectedItems.remove(at: index1)
            }
            setAddViewWithoutQuantity()
        }
    }
    
    func insertItemToBasket(product : [String:String]) -> [String:String]{
        let productInfo = ["id": product[ProductInfo.id.rawValue],
                     "hsn_code": product[ProductInfo.hsn_code.rawValue],
                     "pdt_code": product[ProductInfo.pdt_code.rawValue],
                     "category": product[ProductInfo.category.rawValue],
                     "sub_category": product[ProductInfo.sub_category.rawValue],
                     "pdt_name": product[ProductInfo.pdt_name.rawValue],
                     "pdt_name_tamil": product[ProductInfo.pdt_name_tamil.rawValue],
                     "pdt_description": product[ProductInfo.pdt_description.rawValue],
                    " pdt_unit": product[ProductInfo.pdt_unit.rawValue],
                     "pdt_type": product[ProductInfo.pdt_type.rawValue],
                     "pdt_barcode": product[ProductInfo.pdt_barcode.rawValue],
                     "pdt_price": product[ProductInfo.pdt_price.rawValue],
                     "selling_price": product[ProductInfo.selling_price.rawValue],
                     "mrp": product[ProductInfo.mrp.rawValue],
                     "disc": product[ProductInfo.disc.rawValue],
                     "cgst": product[ProductInfo.cgst.rawValue],
                     "sgst": product[ProductInfo.sgst.rawValue],
                     "available": product[ProductInfo.available.rawValue],
                     "batch": product[ProductInfo.batch.rawValue],
                     "profile_picture": product[ProductInfo.profile_picture.rawValue],
                     "gst_slab": product[ProductInfo.gst_slab.rawValue],
                     "cmp_commission": product[ProductInfo.cmp_commission.rawValue],
                     "selling_percent": product[ProductInfo.selling_percent.rawValue],
                     "warehouse_percent": product[ProductInfo.warehouse_percent.rawValue],
                     "unit_percent": product[ProductInfo.unit_percent.rawValue],
                     "unit_sales_price": product[ProductInfo.unit_sales_price.rawValue],
                     "wh_sales_price": product[ProductInfo.wh_sales_price.rawValue],
                     "status": product[ProductInfo.status.rawValue],
                     "visible": product[ProductInfo.visible.rawValue],
                     "barcode_status":product[ProductInfo.barcode_status.rawValue],
                     "approve_status": product[ProductInfo.approve_status.rawValue],
                     "updated_date": product[ProductInfo.updated_date.rawValue],
                     "updated_by": product[ProductInfo.updated_by.rawValue],
                     "updated_ip": product[ProductInfo.updated_ip.rawValue],
                     "productimage": product[ProductInfo.productimage.rawValue],
                     "qty" : "0"
   
    ]
        return productInfo as! [String : String]
    }
    
    
    
    func addQuantity() {
        let basketItems =  BasketData.userSelectedItems
        let id = iteminfo[ProductInfo.pdt_code.rawValue]
        let filteredArray = basketItems.filter({ $0["pdt_code"] == id  })
        if filteredArray.count == 0 {
            var addItem = insertItemToBasket(product: iteminfo )
            BasketData.badge += 1
            addItem["qty"] = getPQty(qty: (addItem["qty"]!))
            BasketData.userSelectedItems.append(addItem)
            btnBasket.badge = String( BasketData.badge )
        }else {
            var item = filteredArray[0]
            if let index1 = BasketData.userSelectedItems.index(of: item) {
                item["qty"] = getPQty(qty: (item["qty"]!))
                BasketData.userSelectedItems[index1] = item
            }
        }
    }
    
    func minusQuantity(){
        let basketItems =  BasketData.userSelectedItems
        let id = iteminfo[ProductInfo.pdt_code.rawValue]
        let filteredArray = basketItems.filter({ $0["pdt_code"] == id  })
        BasketData.badge -= 1
        btnBasket.badge = String( BasketData.badge )
        var item = filteredArray[0]
            if let index1 = BasketData.userSelectedItems.index(of: item) {
                item["qty"] = getMQty(qty: (item["qty"]!))
                BasketData.userSelectedItems[index1] = item
                
        }
    }
    
    func setAddViewWithQuantity(){
        addView.addButton.isHidden = true
        addView.minusButton.isHidden = false
        addView.quantityLabel.isHidden = false
        addView.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        addView.plusButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    func setAddViewWithoutQuantity(){
        if addView.quantityLabel.text == "0" || addView.quantityLabel.text == "" {
            addView.addButton.isHidden = false
            addView.minusButton.isHidden = true
            addView.quantityLabel.isHidden = true
            addView.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex:ColorCode.LightGrayColorCode.rawValue , alphavalue: 1)
            addView.plusButton.setTitleColor(UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1), for: .normal)
            }
        
    }
    @objc func didPlusButtonTapped() {
        var value = Int(addView.quantityLabel.text!)
        value! += 1
        setQuantityValue(value: value!)
        
      }
    
    @objc func didMinusButtonTapped(btn : UIButton) {
        var value = Int(addView.quantityLabel.text!)
        value = value! - 1
        setMinusQuantityValue(value: value!)
      }
    
    
    
    func handleAddButtonEvent(btn : UIButton) {
        addView.addButton.isHidden = true
        addView.minusButton.isHidden = false
        addView.quantityLabel.isHidden = false
        addView.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        addView.plusButton.setTitleColor(UIColor.white, for: .normal)
        addView.quantityLabel.text = "1"
    }
    
    @IBAction func didPressedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

public struct ViewProductRootClass :Decodable {
    
    public var Response : [ViewProductResponse]!
    public var Results : [ViewProductResult]!
    
}
public struct ViewProductResult :Decodable {
    public var id: String!
   public var district: String!
   public var hsn_code: String!
   public var pdt_code: String!
   public var category: String!
   public var sub_category: String!
   public var pdt_name: String!
   public var pdt_name_tamil: String!
   public var pdt_description: String!
   public var pdt_unit: String!
   public var pdt_weight_kg: String!
   public var pdt_weight_ltr: String!
   public var pdt_type: String!
   public var pdt_barcode: String!
   public var pdt_price: String!
   public var selling_price: String!
   public var mrp: String!
   public var disc: String!
   public var cgst: String!
   public var sgst: String!
   public var available: String!
   public var batch: String!
   public var profile_picture: String!
   public var gst_slab: String!
   public var cmp_commission: String!
   public var selling_percent: String!
   public var warehouse_percent: String!
   public var unit_percent: String!
   public var unit_sales_price: String!
   public var wh_sales_price: String!
   public var corporate_selling_price: String!
   public var vendor: String!
   public var status: String!
   public var visible: String!
   public var barcode_status: String!
   public var website_status: String!
   public var approve_status: String!
   public var specialsales_status: String!
   public var updated_date: String!
   public var updated_by: String!
   public var updated_ip: String!
   public var deleted_status: String!
   public var productimage: String!
   public var minqty : String!
    
}
public struct ViewProductResponse : Decodable  {
    
    public var response_code : String!
    public var response_msg : String!
    
}
