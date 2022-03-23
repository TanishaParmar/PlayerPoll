//
//  LeaderboardCell.swift
//  PlayerPoll
//
//  Created by mac on 26/10/21.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    @IBOutlet weak var rankLbl: PPOthersBoardLabel!
    
    @IBOutlet weak var scoreLbl: PPPollstersPointsLabel!
    @IBOutlet weak var nameLbl: PPParticipantNameLabel!
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
