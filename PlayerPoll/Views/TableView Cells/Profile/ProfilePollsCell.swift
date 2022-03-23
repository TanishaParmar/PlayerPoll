//
//  ProfilePollsCell.swift
//  PlayerPoll
//
//  Created by mac on 25/10/21.
//

import UIKit

class ProfilePollsCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var catLbl: PPLoginMediumLabel!
    @IBOutlet weak var pollLbl: PPListViewPollLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
