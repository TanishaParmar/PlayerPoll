//
//  UnAnsweredOptionCell.swift
//  PlayerPoll
//
//  Created by mac on 20/10/21.
//

import UIKit

class UnAnsweredOptionCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var answerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
