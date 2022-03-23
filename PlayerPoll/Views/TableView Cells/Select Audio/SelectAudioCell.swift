//
//  SelectAudioCell.swift
//  PlayerPoll
//
//  Created by mac on 30/12/21.
//

import UIKit

class SelectAudioCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var audioFileImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLbl: PPFlagNameLabel!
    @IBOutlet weak var playBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
