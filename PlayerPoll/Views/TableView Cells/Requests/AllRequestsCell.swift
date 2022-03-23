//
//  AllRequestsCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 12/11/21.
//

import UIKit

class AllRequestsCell: UITableViewCell {

    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var amountLbl: PPAllRequestWhiteLabel!
    @IBOutlet weak var dateLbl: PPAllRequestWhiteLabel!
    @IBOutlet weak var nameLbl: PPAllRequestWhiteLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
