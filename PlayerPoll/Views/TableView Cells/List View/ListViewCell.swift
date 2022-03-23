//
//  ListViewCell.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var readImageView: UIImageView!
    @IBOutlet weak var pollLbl: PPListViewPollLabel!
    @IBOutlet weak var catLbl: PPLoginMediumLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
