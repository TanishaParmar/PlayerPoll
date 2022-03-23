//
//  PollListingCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 17/11/21.
//

import UIKit

class PollListingCell: UITableViewCell {

    @IBOutlet weak var lblTime: PPEditPollTimeLabel!
    @IBOutlet weak var lblCategoryId: PPEditPollCategoryLabel!
    @IBOutlet weak var lblName: PPEditPollNameLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
