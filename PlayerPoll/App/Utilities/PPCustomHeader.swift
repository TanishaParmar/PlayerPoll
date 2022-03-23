//
//  PPCustomHeader.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

class PPCustomHeader{
    
    class func setNavHeaderView(view: UIView, title: String, showBack: Bool, alignMiddle: Bool = false, delegate: NavHeaderDelegate, showAdd:Bool = false, addBlock: (()->Void)? = nil){
        let nib:NavHeaderView = NavHeaderView.fromNib()
        nib.frame = view.frame
        view.addSubview(nib)
        nib.titleLbl.text = title
        nib.backBtn.isEnabled = showBack
        nib.titleLbl.textAlignment = alignMiddle ? .center : .left
        nib.backImageView.isHidden = !showBack
        nib.delegate = delegate
        nib.addBtn.isEnabled = showAdd
        nib.addImageView.isHidden = !showAdd
        nib.addBtnAction = {
            addBlock?()
        }
    }
    
    class func setSaveHeaderView(view: UIView, title: String, showBack: Bool, alignMiddle: Bool = false, delegate: NavHeaderDelegate, showAdd:Bool = true, saveBlock: (()->Void)? = nil){
        let nib:SaveHeaderView = SaveHeaderView.fromNib()
        nib.frame = view.frame
        view.addSubview(nib)
        nib.titleLbl.text = title
        nib.backBtn.isEnabled = showBack
        nib.titleLbl.textAlignment = alignMiddle ? .center : .left
        nib.backImageView.isHidden = !showBack
        nib.delegate = delegate
        nib.addBtn.isEnabled = showAdd
        nib.addBtnAction = {
            saveBlock?()
        }
    }
    
    class func setProfileNavHeaderView(view: UIView, title: String, showBack: Bool, alignMiddle: Bool = false, delegate: NavHeaderDelegate, showSetting:Bool = false, settingBlock: (()->Void)? = nil){
        let nib:NavHeaderView = NavHeaderView.fromNib()
        nib.frame = view.frame
        view.addSubview(nib)
        nib.titleLbl.text = title
        nib.backBtn.isEnabled = showBack
        nib.titleLbl.textAlignment = alignMiddle ? .center : .left
        nib.backImageView.isHidden = !showBack
        nib.delegate = delegate
        nib.addBtn.isEnabled = false
        nib.addImageView.isHidden = true
        nib.settingBtn.isEnabled = showSetting
        nib.settingImageView.isHidden = !showSetting
        nib.settingButtonAction = {
            settingBlock?()
        }
    }
}
