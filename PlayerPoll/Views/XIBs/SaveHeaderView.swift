//
//  SaveHeaderView.swift
//  PlayerPoll
//
//  Created by mac on 21/12/21.
//

import UIKit

class SaveHeaderView: UIView {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: PPNavTitleLabel!
    var delegate: NavHeaderDelegate?
    var addBtnAction: (()->Void)?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.delegate?.backAction()
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        addBtnAction?()
    }

}
