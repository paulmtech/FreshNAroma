import UIKit
import TransitionButton
class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var wikiImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAddtoCart: TransitionButton!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewQuantity: QuantitySelectorView!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var btnProductImage: UIButton!
    var cellDelegate : SubMenuListDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        setAddViewProperties()
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
    func setQuantityValue(value : Int) {
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
    
    
    func setAddViewWithQuantity() {
        viewQuantity.addButton.isHidden = true
        viewQuantity.minusButton.isHidden = false
        viewQuantity.quantityLabel.isHidden = false
        viewQuantity.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        viewQuantity.plusButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
  func setAddViewWithoutQuantity() {
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
        viewQuantity.plusButton.backgroundColor = UIColor.hexStringToUIColor(hex:ColorCode.GreenColorCOde.rawValue, alphavalue: 1)
        viewQuantity.plusButton.setTitleColor(UIColor.white, for: .normal)
        
        viewQuantity.quantityLabel.text = "1"
        cellDelegate.didAddButtonTapped(btn : btn)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
