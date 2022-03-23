//
//  Home.swift
//  PlayerPoll
//
//  Created by mac on 26/11/21.
//

import Foundation
import UIKit

struct HomeResponseModal: Codable {
    let status: Int
    let message: String
    let lastPage:Bool?
    let data: [HomePolls]?
}

struct HomePolls: Codable {
    let pID, userID, pollText, catID: String
    let bgID, sponsorID, points, created: String
    let isAnswer, submitOptionID: String
    let categoryDetails: CategoryDetails
    let backgroundDetails: BackgroundDetails
    let sponsorDetails: SponsorDetails
    let optionsDetails: [OptionsDetail]
    let submitAnswerUserDetails: [SubmitAnswerUserDetail]
    
    func userAnswered()->Bool{
        return isAnswer == "1"
    }
    func getReadStatusImage()->UIImage{
        if isAnswer == "1"{
            return UIImage(named: "unRead")!
        }
        return UIImage(named: "read")!
    }
    func getCreationDateString(format: String)->String{
        let timeStamp = created.toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: date)
    }

    
    func getCreationDate()->Date{
        let timeStamp = created.toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return date
    }
    var convertedString:String?
    
   
    
    func getRandomColor()->UIColor?{
        return [#colorLiteral(red: 0.001436090795, green: 0.2898610532, blue: 0.6811991334, alpha: 1),#colorLiteral(red: 0.7415030599, green: 0.0007053050213, blue: 0.4562799931, alpha: 1),#colorLiteral(red: 0.5635025501, green: 0.001263548504, blue: 0, alpha: 1),#colorLiteral(red: 0.8403177857, green: 0.2550058365, blue: 0.00191572425, alpha: 1),#colorLiteral(red: 0.8099532723, green: 0.3675017655, blue: 0.9648931623, alpha: 1)].shuffled().first
    }
}

struct BackgroundDetails: Codable {
    let bgID, catID, bgName: String
    let bgImage: String
    let created: String
}

struct CategoryDetails: Codable {
    let catID, title, catImage, audioFile, catColor, created: String
    
    func getCatColor()->UIColor{
        if catColor.isEmpty{
            return #colorLiteral(red: 0.8099532723, green: 0.3675017655, blue: 0.9648931623, alpha: 1)
        }
        return UIColor(hexString: catColor)
    }
}

struct OptionsDetail: Codable {
    let optionID, pID, options, optionsCode: String
    let created, percentage: String
}

struct SponsorDetails: Codable {
    let sponsorID, sponsorName: String
    let sponsorImage: String
    let created: String
}

struct SubmitAnswerUserDetail: Codable {
    let userID, userName, email, password: String
    let userRole: String
    let profileImage: String
    let bio, userIdentify, userAgeGroup, notificationDisable: String
    let diamondPoints, thunderPoints, created, verificationCode: String
    let verified, facebookToken, profileComplete, appleToken: String
    let authToken: String
}


struct CategoryAudioResponseModal: Codable {
    let status: Int
    let message: String
    let data: [AudioData]?
}

// MARK: - Datum
struct AudioData: Codable {
    let audID, catID: String
    let audioFile: String
    let created: String
    
}

struct AudioUserParse{
    var data: AudioData
    var selected:Bool = false
    
    func getPathComponent()->String{
        if let fileName = URL(string: data.audioFile)?.lastPathComponent{
            return fileName
        }else{
            return data.audioFile
        }
    }
}
