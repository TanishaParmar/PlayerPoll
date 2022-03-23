//
//  FlagSelectionCell.swift
//  PlayerPoll
//
//  Created by mac on 21/12/21.
//

import UIKit

class FlagSelectionCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var flagNameLbl: PPFlagNameLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
