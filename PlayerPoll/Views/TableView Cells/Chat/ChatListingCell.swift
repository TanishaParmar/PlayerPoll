//
//  ChatListingCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 16/11/21.
//

import UIKit

class ChatListingCell: UITableViewCell {

    @IBOutlet weak var unreadCountLbl: PPChatUnreadCountLabel!
    @IBOutlet weak var unreadLbl: UILabel!
    @IBOutlet weak var lblTime: PPChatListingTimeLabel!
    @IBOutlet weak var lblDescription: PPChatListingDescriptionLabel!
    @IBOutlet weak var lblName: PPChatListingNameLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
