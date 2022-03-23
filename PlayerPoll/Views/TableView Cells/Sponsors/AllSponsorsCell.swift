//
//  AllSponsorsCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class AllSponsorsCell: UITableViewCell {
    @IBOutlet weak var nameLbl: PPSponsorsWhiteNameLabel!
    @IBOutlet weak var imgSponsors: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
