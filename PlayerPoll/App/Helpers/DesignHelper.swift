//
//  DesignHelper.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit


class DesignHelper{
    static func setSignupTextView()->NSMutableAttributedString{
        let mainString = "Don't have an account? Sign up"
        let attributedString = NSMutableAttributedString(string: mainString)
        let string1 = "Don't have an account? "
        let rangeString = (mainString as NSString).range(of: string1)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16),NSMutableAttributedString.Key.foregroundColor:PPColor.white], range: rangeString)
        let string2 = "Sign up"
        let range2String = (mainString as NSString).range(of: string2)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow], range: range2String)
        let url = URL(string: "www.google.com")
        attributedString.addAttributes([NSMutableAttributedString.Key.link:url as Any], range: range2String)
        return attributedString
    }
    static func setSignInTextView()->NSMutableAttributedString{
        let mainString = "Already have an account? Log in"
        let attributedString = NSMutableAttributedString(string: mainString)
        let string1 = "Already have an account? "
        let rangeString = (mainString as NSString).range(of: string1)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16),NSMutableAttributedString.Key.foregroundColor:PPColor.white], range: rangeString)
        let string2 = "Log in"
        let range2String = (mainString as NSString).range(of: string2)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow], range: range2String)
        let url = URL(string: "www.google.com")
        attributedString.addAttributes([NSMutableAttributedString.Key.link:url as Any], range: range2String)
        return attributedString
    }
    
    static func setTermsTextView()->NSMutableAttributedString{
        let mainString = "I agree with the Privacy Policy"
        let attributedString = NSMutableAttributedString(string: mainString)
        let string1 = "I agree with the "
        let rangeString = (mainString as NSString).range(of: string1)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16),NSMutableAttributedString.Key.foregroundColor:PPColor.white], range: rangeString)
        let string2 = "Privacy Policy"
        let range2String = (mainString as NSString).range(of: string2)
        attributedString.addAttributes([NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow], range: range2String)
        let url = URL(string: "https://www.playerpoll.com/terms")
        attributedString.addAttributes([NSMutableAttributedString.Key.link:url as Any], range: range2String)
        return attributedString
    }
    
    static func getStreakValue(points: Int)->NSAttributedString{
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "streak")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(points)"))
        return fullString
    }

    static func getPointsValue(points: Int)->NSAttributedString {
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "totalPoints")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(points)"))
        return fullString
    }
    
    static func setQuestionPoints(lbl: PPHomePointsLabel, lblCategory: PPHomeAnalyticsLabel, poll: HomePolls){
        lbl.text = "   \(poll.points) PTS   "
        lbl.backgroundColor = poll.userAnswered() ? PPColor.pointsGreen : PPColor.bgYellow
        lblCategory.text = poll.categoryDetails.title.uppercased()
    }
    
    static func createEmptyView(title: String) -> EmptyView {
        let emptyView: EmptyView = EmptyView.fromNib()
        emptyView.emptyLbl.text = title
        return emptyView
    }
    
    static func returnMessagesTime(timeString: String)->String{
        let timeInterval = timeString.toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let formatter = DateFormatter()
        formatter.timeZone = .current
        if Calendar.current.isDateInToday(date){
            formatter.dateFormat = "hh:mm a"
        }else{
            formatter.dateFormat = "dd MMM"
        }
        return formatter.string(from: date)
    }
    
    static func getFirstName(name: String)->String{
        var components = name.components(separatedBy: " ")
        if components.count > 0 {
            let firstName = components.removeFirst()
            return firstName
        }else{
            return name
        }
    }
    
}


