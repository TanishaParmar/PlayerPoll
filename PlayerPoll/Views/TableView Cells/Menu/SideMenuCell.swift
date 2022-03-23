//
//  SideMenuCell.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var settingLbl: PPSideMenuOptionLabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var menuIconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
