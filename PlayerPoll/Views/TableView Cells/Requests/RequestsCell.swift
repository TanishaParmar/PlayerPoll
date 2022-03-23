//
//  RequestsCell.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 12/11/21.
//

import UIKit

class RequestsCell: UITableViewCell {

    @IBOutlet weak var amountLbl: PPRequestWhiteLabel!
    @IBOutlet weak var DateLbl: PPRequestWhiteLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
