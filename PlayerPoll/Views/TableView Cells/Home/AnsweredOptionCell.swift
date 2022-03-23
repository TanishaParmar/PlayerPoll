//
//  AnsweredOptionCell.swift
//  PlayerPoll
//
//  Created by mac on 20/10/21.
//

import UIKit

class AnsweredOptionCell: UITableViewCell {
    @IBOutlet weak var optionLbl: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var percLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
