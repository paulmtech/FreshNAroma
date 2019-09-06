//
//  HotOffersTableViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 06/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
protocol SubMenuListDelegate {
    
    func didAddButtonTapped(btn : UIButton)
    func didMinusButtonTapped(btn: UIButton)
}




class QuantitySelectorView : UIView {
    
    var addButton = UIButton()
    var plusButton = UIButton()
    var minusButton = UIButton()
    var quantityLabel = UILabel()
//    var activty =  
    var isPropertisSet = false
    var cellDelegate : SubMenuListDelegate!
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    
    
    override func layoutSubviews() {
        
        let buttonWidth = self.frame.width / 3
        
        minusButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: self.frame.height)
        quantityLabel.frame = CGRect(x: minusButton.frame.maxX, y: 0, width: buttonWidth, height: self.frame.height)
        plusButton.frame = CGRect(x: quantityLabel.frame.maxX, y: 0, width: buttonWidth, height: self.frame.height)
        
        addButton.frame = CGRect(x: 0, y: 0, width: buttonWidth * 2, height: self.frame.height)
        
    }
    func createControls() {
        
        setCorner()
        
        setPropertiesForAddButton()
        setPropertiesForPlusButton()
        setPropertiesForMinusButton()
        setPropertiesForQuantityLabel()
        
        self.addSubview(minusButton)
        self.addSubview(quantityLabel)
        self.addSubview(plusButton)
        self.addSubview(addButton)
        
        minusButton.isHidden = true
        quantityLabel.isHidden = true
        
    }
    func setPropertiesForAddButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1), for: .normal)
        addButton.backgroundColor = UIColor.white
        
        
    }
    
    
    func setPropertiesForPlusButton() {
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1), for: .normal)
        plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.LightGrayColorCode.rawValue, alphavalue: 1)
        
        
        
    }
    func setPropertiesForMinusButton() {
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(UIColor.white, for: .normal)
        minusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        
    }
    
    func setPropertiesForQuantityLabel() {
        quantityLabel.textColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        quantityLabel.textAlignment = .center
        quantityLabel.text = "0"
        //quantityLabel.font = FONT_BOLD(size: 17)
        
    }
    
    func setCorner() {
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1).cgColor
        self.layer.borderWidth = 1
        
        self.clipsToBounds = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
class HotOffersTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewQuantity: QuantitySelectorView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDiscription: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTotal: UILabel!
    @IBOutlet weak var itemPriceTagImage: UIImageView!
    var cellDelegate : SubMenuListDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
       setAddViewProperties()
        // Initialization code
    }
    func setAddViewProperties() {
        if viewQuantity != nil  && !viewQuantity.isPropertisSet {
            
            viewQuantity.isPropertisSet = true
            viewQuantity.createControls()
            viewQuantity.addButton.addTarget(self, action: #selector(HotOffersTableViewCell.didPlusButtonTapped(btn:)), for: .touchUpInside)
            viewQuantity.plusButton.addTarget(self, action: #selector(HotOffersTableViewCell.didPlusButtonTapped(btn:)), for: .touchUpInside)
            viewQuantity.minusButton.addTarget(self, action: #selector(HotOffersTableViewCell.didMinusButtonTapped(btn:)), for: .touchUpInside)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
   public func setQuantityValue(value : Int) {
        viewQuantity.quantityLabel.text = "\(value)"
        if value > 0 {
           // quantityLabel.text = "\(value)X"
            setAddViewWithQuantity()
        }
        else {
           // quantityLabel.text = ""
            setAddViewWithoutQuantity()
        }
    }
    
    
   public func setAddViewWithQuantity() {
        viewQuantity.addButton.isHidden = true
        viewQuantity.minusButton.isHidden = false
        viewQuantity.quantityLabel.isHidden = false
        viewQuantity.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        viewQuantity.plusButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
   public func setAddViewWithoutQuantity() {
         if viewQuantity.quantityLabel.text == "0" || viewQuantity.quantityLabel.text == "" {
            viewQuantity.addButton.isHidden = false
            viewQuantity.minusButton.isHidden = true
            viewQuantity.quantityLabel.isHidden = true
            viewQuantity.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.LightGrayColorCode.rawValue, alphavalue: 1)
            viewQuantity.plusButton.setTitleColor(UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1), for: .normal)
            
        }
        
    }
    @objc func didPlusButtonTapped(btn : UIButton) {
 
        setAddViewWithQuantity()
        cellDelegate.didAddButtonTapped(btn : btn)
        
    }
    
    @objc func didMinusButtonTapped(btn : UIButton) {
       setAddViewWithoutQuantity()
       cellDelegate.didMinusButtonTapped(btn : btn)
        
    }
    
    
    
    func handleAddButtonEvent(btn : UIButton) {
        viewQuantity.addButton.isHidden = true
        viewQuantity.minusButton.isHidden = false
        viewQuantity.quantityLabel.isHidden = false
        viewQuantity.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        viewQuantity.plusButton.setTitleColor(UIColor.white, for: .normal)
        
        viewQuantity.quantityLabel.text = "1"
        cellDelegate.didAddButtonTapped(btn : btn)
        
    }
    @IBAction func didPressedAddButton(_ sender: Any) {
        
    }
    @IBAction func didPrssedPlusButton(_ sender: Any) {
      
    }
}
