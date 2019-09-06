//
//  MyOrderTableViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 02/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
@objc protocol MyOrderButtonDelegate {
    func didpressedViewOrderButton(_ tag: Int)
    func didPressedOrderTrackButton(_ tag: Int)
  @objc optional func didPressedRateUsButton(_ tag: Int)
}
class MyOrderTableViewCell: UITableViewCell {
    weak var cellDelegate: MyOrderButtonDelegate?
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var btnOrderDeataile: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblItem: UILabel!
    
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func didPressedOrderDetails(_ sender: UIButton) {
        cellDelegate?.didpressedViewOrderButton(sender.tag)
    }
    @IBAction func didPressedOrderTrack(_ sender: UIButton) {
        cellDelegate?.didPressedOrderTrackButton(sender.tag)
    }
}
class MyOrderWithRateTableViewCell: UITableViewCell {
    weak var cellDelegate: MyOrderButtonDelegate?
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var btnOrderDeataile: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblItem: UILabel!
    
    @IBOutlet weak var btnShowRateView: UIButton!
    @IBOutlet weak var starRateView: FloatRatingView!
    @IBOutlet weak var viewWriteReview: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func didPressedOrderDetails(_ sender: UIButton) {
        cellDelegate?.didpressedViewOrderButton(sender.tag)
    }
    @IBAction func didPressedOrderTrack(_ sender: UIButton) {
        cellDelegate?.didPressedOrderTrackButton(sender.tag)
    }
    
    
    @IBAction func didPressedRateButton(_ sender: UIButton) {
        
        cellDelegate?.didPressedRateUsButton?(sender.tag)
        
    }
}
