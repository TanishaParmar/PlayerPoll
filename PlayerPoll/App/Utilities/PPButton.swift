//
//  PPButton.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit

class PBBaseButton: UIButton {

    var fontDefaultSize : CGFloat {
        return self.titleLabel?.font.pointSize ?? 0.0
    }
    var fontSize : CGFloat = 0.0

}

//MARK:- Login
class PPLoginTextButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        titleLabel?.font = PPFont.codeProBold(size: 15)
        setTitleColor(PPColor.white, for: .normal)
    }
}

class PPLoginButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = PPColor.bgYellow
        titleLabel?.font = PPFont.codeProBold(size: 20)
        setTitleColor(PPColor.buttonBlue, for: .normal)
    }
}

//MARK:- Identifier

class PPDoneIdentifierButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = PPColor.skyBlue
        titleLabel?.font = PPFont.codeProBold(size: 20)
        setTitleColor(PPColor.white, for: .normal)
    }
}

//MARK:- Settings

class PPUploadButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 18)
        setTitleColor(PPColor.bgYellow, for: .normal)
    }
}


class PPHeaderSaveButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 16)
        setTitleColor(PPColor.white, for: .normal)
    }
}


class PPLogoutButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 20)
        setTitleColor(PPColor.white, for: .normal)
    }
}

//Mark:- Sponsors
class PPSponsorsUploadButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 16)
        setTitleColor(PPColor.bgYellow, for: .normal)
    }
}

class PPSponsorsRemoveImageButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 15)
        setTitleColor(PPColor.white, for: .normal)
    }
}

class PPSponsorsSaveImageButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 15)
        setTitleColor(PPColor.white, for: .normal)
        titleLabel?.backgroundColor = #colorLiteral(red: 0.2194843292, green: 0.706982553, blue: 0.9879944921, alpha: 1)
    }
}

//Mark:- BackGrounds
class PPBackgroundsUploadButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 16)
        setTitleColor(PPColor.bgYellow, for: .normal)
    }
}

class  PPBackgroundsRemoveImageButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 15)
        setTitleColor(PPColor.white, for: .normal)
    }
}

class PPBackgroundsSaveImageButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProBold(size: 18)
        setTitleColor(PPColor.white, for: .normal)
        titleLabel?.backgroundColor = #colorLiteral(red: 0.2194843292, green: 0.706982553, blue: 0.9879944921, alpha: 1)
    }
}


class PPEditIdentifierButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProExtraBold(size: 16)
        setTitleColor(PPColor.white, for: .normal)
    }
}


//MARK:- Review Payment Request

class PPMarkPaidButton: PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.font = PPFont.codeProExtraBold(size: 16)
        setTitleColor(PPColor.identifierBlue, for: .normal)
        backgroundColor = PPColor.white
        self.cornerRadius = 8
    }
}


//MARK:- Flags Listing Screen

class PPFlagSelectButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("Select", for: .normal)
        titleLabel?.font = PPFont.codeProExtraBold(size: 16)
        setTitleColor(PPColor.white, for: .normal)
        backgroundColor = PPColor.identifierBlue
    }
}


//MARK:- Forgot Password Screen

class PPForgotSubmitButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("SUBMIT", for: .normal)
        titleLabel?.font = PPFont.codeProExtraBold(size: 19)
        setTitleColor(PPColor.identifierBlue, for: .normal)
        backgroundColor = PPColor.white
    }
}


//MARK:- Color Picker Screen

class PPColorPickerButton:PBBaseButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("PICK", for: .normal)
        titleLabel?.font = PPFont.codeProExtraBold(size: 17)
        setTitleColor(PPColor.white, for: .normal)
        backgroundColor = PPColor.identifierBlue
    }
}



