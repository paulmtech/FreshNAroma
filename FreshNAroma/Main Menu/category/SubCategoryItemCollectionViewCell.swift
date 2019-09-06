//
//  SubCategoryItemCollectionViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 26/11/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import TransitionButton

class SubCategoryItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgProductimage: UIImageView!
    @IBOutlet weak var lblSellingPrice: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblPdtName: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblMrp: UILabel!
   // @IBOutlet weak var addView: QuantitySelectorView!
    @IBOutlet weak var btnProductImage: UIButton!
    @IBOutlet weak var btnAddtoCart: TransitionButton!
    
    var isPropertisSet = false
    var cellDelegate : SubMenuListDelegate!
        
        // this will be our "call back" action
        var btnTapAction : (()->())?
        
        override init(frame: CGRect){
            super.init(frame: frame)
           // setupViews()
             //setAddViewProperties()
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        
      // setAddViewProperties()
    }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
           // setupViews()
           
        }
}
  

