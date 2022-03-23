//
//  PollstersCell.swift
//  PlayerPoll
//
//  Created by mac on 21/10/21.
//

import UIKit

class PollstersCell: UITableViewCell {

    @IBOutlet weak var messageImgView: UIImageView!
    @IBOutlet weak var nameLbl: PPPollsterNameLabel!
    @IBOutlet weak var pointsLbl: PPPollstersPointsLabel!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
