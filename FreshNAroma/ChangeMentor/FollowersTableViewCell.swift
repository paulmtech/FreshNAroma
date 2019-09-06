//
//  FollowersTableViewCell.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 21/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
