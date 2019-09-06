//
//  ProductViewTableViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 25/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

import AlamofireImage
import Alamofire
import TransitionButton
class ProductViewTableViewCell: UITableViewCell {

   
    @IBOutlet weak var viewSaved: UIView!
    @IBOutlet weak var btnAdd: TransitionButton!
    @IBOutlet weak var lblSaved: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var btnProductImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func displayProductCell(_ product: OffersResult ){
        lblTitle.text = product.pdt_name
        let pdt_price = (product.selling_price as NSString).floatValue
        lblPrice.text = String(format: "\(RupeeSymbol)%.2f",pdt_price)
        let discount = floatFromString(stringValue:product.disc)
        if discount > 0 {
           lblSaved.text = String(format:" You Save \(RupeeSymbol)%.2f ",discount)
            
       lblSaved.isHidden = false;
            
            
        } else {
          lblSaved.isHidden = true;
        }
        let mrp : Float = (product.mrp as NSString ).floatValue
        if(pdt_price < mrp) {
          lblMrp.text = String(format: "MRP:\(RupeeSymbol)%.2f",mrp)
            let attributedString = NSMutableAttributedString(string:  lblMrp.text!)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
           lblMrp.attributedText = attributedString
          lblMrp.isHidden = false
            
        }else{
         lblMrp.isHidden = true
        }
        
        
        let url = product.productimage
        let urlStr : NSString = url!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        imgProduct.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size:imgProduct.frame.size))
        
        viewSaved.layer.cornerRadius = 10.00
        viewSaved.clipsToBounds = true
        imgProduct.layer.cornerRadius = 2
        imgProduct.clipsToBounds = true
        imgProduct.layer.borderWidth = 0.05
        
        btnAdd.spinnerColor = .white
        btnAdd.cornerRadius = 5.00
        viewSaved.layer.cornerRadius = 10.00
        viewSaved.clipsToBounds = true
        imgProduct.layer.cornerRadius = 2
        imgProduct.clipsToBounds = true
        imgProduct.layer.borderWidth = 0.05
        
        btnAdd.spinnerColor = .white
        btnAdd.cornerRadius = 5.00
    }
   
}
    

