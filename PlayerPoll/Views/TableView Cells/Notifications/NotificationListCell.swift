//
//  NotificationListCell.swift
//  PlayerPoll
//
//  Created by mac on 26/10/21.
//

import UIKit

class NotificationListCell: UITableViewCell {
    @IBOutlet weak var notifTitleLbl: PPNotifTitleLabel!
    
    @IBOutlet weak var topSeperatorLbl: UILabel!
    @IBOutlet weak var notifImageView: UIImageView!
    @IBOutlet weak var dateLbl: PPNotifDateLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
