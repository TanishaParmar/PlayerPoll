//
//  PollSelectCell.swift
//  PlayerPoll
//
//  Created by Phani's MacBook Pro on 19/01/22.
//

import UIKit

class PollSelectCell: UITableViewCell {

    @IBOutlet weak var nameLbl: PPPollSelectNameLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
