//
//  ManageBackgroundsListingCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class ManageBackgroundsListingCell: UITableViewCell {

    @IBOutlet weak var imgBackgrounds: UIImageView!
    @IBOutlet weak var backgroundLbl: PPManageBackgroundsWhiteNameLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
