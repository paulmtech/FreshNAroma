//
//  CategoryCellTableViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 10/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class CategoryCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
