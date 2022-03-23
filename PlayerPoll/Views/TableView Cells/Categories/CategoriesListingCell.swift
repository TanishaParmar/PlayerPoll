//
//  CategoriesListingCell.swift
//  PlayerPoll
//
//  Created by mac on 24/12/21.
//

import UIKit

class CategoriesListingCell: UITableViewCell {

    @IBOutlet weak var catNameLbl: PPEditPollNameLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
