//
//  PPLabel.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import Foundation
import UIKit

class PPBaseLabel: UILabel{
    var fontDefaultSize : CGFloat {
        return font?.pointSize ?? 0.0
    }
    var fontSize : CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK:- Login
class PPLoginMediumLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = .white
    }
}
class PPLoginRegularSubtitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
    }
}

//MARK:- Identifier
class PPIdentifierSubHeadLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 13)
        self.textColor = .white
    }
}


class PPIdentifierAgeLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 18)
        self.textColor = .white
    }
}

//MARK:- Side Menu
class PPSideMenuProfileNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 18)
        self.minimumScaleFactor = 0.6
        self.textColor = .white
    }
}

class PPAnalyticsLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 16)
        self.textColor = PPColor.analyticsText
    }
}

class PPSideMenuOptionLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = PPColor.identifierBlue
    }
}

//MARK:- Nav Header
class PPNavTitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = PPColor.white
    }
}


//MARK:- List View

class PPListViewPollLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 14)
        self.textColor = PPColor.white
    }
}

//MARK:- Home

class PPHomeAnalyticsLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = PPColor.white
    }
}

class PPHomePointsLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
        self.textColor = PPColor.black
        self.backgroundColor = PPColor.pointsGreen
        self.cornerRadius = 10
        self.clipsToBounds = true
    }
}

//MARK:- PollSters

class PPPollstersQuestionLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = PPColor.white
    }
}

class PPPollsterNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
        self.textColor = PPColor.white
    }
}


class PPPollstersPointsLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
        self.textColor = PPColor.identifierBlue
    }
}


//MARK:- Profile Screen


class PPProfileNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 19)
        self.textColor = .white
    }
}


class PPProfileRankLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 14)
        self.textColor = PPColor.bgYellow
    }
}


class PPProfileSubTitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 14)
        self.textColor = PPColor.white
    }
}

//MARK:- Notifications Screen

class PPNotifTitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = .white
    }
}

class PPNotifDateLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 12)
        self.textColor = PPColor.bgYellow
    }
}


//MARK:- Leaderboard Screen


class PPWinnerBoardLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.conthrax(size: 70)
        self.textColor = PPColor.bgYellow
    }
}

class PPRunnerBoardLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.conthrax(size: 48)
        self.textColor = .white
    }
}

class PPOthersBoardLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.conthrax(size: 23)
        self.textColor = PPColor.identifierBlue
    }
}


class PPParticipantNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
        self.textColor = PPColor.identifierBlue
    }
}


//MARK:- Super Admin Options(Requests) Screen

class PPRequestWhiteLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = PPColor.white
    }
}
class PPRequestYellowLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = PPColor.bgYellow
    }
}
class PPAllRequestWhiteLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = PPColor.white
    }
}
//MARK:- Super Admin Options(Sponsors) Screen
class PPSponsorsWhiteNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = PPColor.white
    }
}

//MARK:- Super Admin Options(ManageBackgrounds) Screen
class PPManageBackgroundsWhiteNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = PPColor.white
    }
}

//MARK:- Super Admin Options(Analytics) Screen
class PPAnalyticsListingWhiteNumberLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 40)
        self.textColor = PPColor.white
    }
}
class PPAnalyticsYellowLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 12)
        self.textColor = PPColor.bgYellow
    }
}
//MARK:- Chat Details Screen

class PPChatNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 16)
        self.textColor = .white
    }
}

//MARK:- Chat Listing Screen

class PPChatListingNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 16)
        self.textColor = .white
    }
}
class PPChatListingDescriptionLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 15)
        self.textColor = .white
    }
}
class PPChatListingTimeLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 12)
        self.textColor = .white
    }
}

class PPChatUnreadCountLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 10)
        self.textColor = .white
    }
}

//MARK:- Edit Poll Listing Screen

class PPEditPollNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 18)
        self.textColor = .white
    }
}
class PPEditPollCategoryLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 16)
        self.textColor = .white
    }
}
class PPEditPollTimeLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 13)
        self.textColor = .white
    }
}

//MARK:- Edit Poll Details Screen

class PPEditPollTitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = .white
    }
}

//MARK:- Select BG Sponsor Screen

class PPSelectBGSponsorLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 16)
        self.textColor = PPColor.identifierBlue
    }
}


//MARK:- Empty Data Label

class PPEmptyDataLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 16)
        self.textColor = PPColor.white
    }
}


//MARK:- Flags Listing Screen
class PPFlagNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 16)
        self.textColor = .white
    }
}

//MARK:- Forgot Password Screen
class PPForgotTitleLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 28)
        self.textColor = .white
    }
}


class PPForgotDescLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 18)
        self.textColor = .white
    }
}

//MARK: Poll Select Screen
class PPPollSelectNameLabel:PPBaseLabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProExtraBold(size: 16)
    }
}
