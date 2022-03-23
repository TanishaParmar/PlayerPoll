//
//  NavHeaderView.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

protocol NavHeaderDelegate {
    func backAction()
}

class NavHeaderView: UIView {

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var titleLbl: PPNavTitleLabel!
    @IBOutlet weak var settingBtn: UIButton!
    var delegate: NavHeaderDelegate?
    var addBtnAction: (()->Void)?
    var settingButtonAction: (()->Void)?
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
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        addBtnAction?()
    }
    
    @IBAction func settingBtnAction(_ sender: Any) {
        settingButtonAction?()
    }
    
}
