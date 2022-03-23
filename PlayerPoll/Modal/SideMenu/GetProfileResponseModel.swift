//
//  GetProfileResponseModel.swift
//  PlayerPoll
//
//  Created by MyMac on 11/9/21.
//

import Foundation


// MARK: - GetProfileResponseModel
struct GetProfileResponseModel: Codable {
    var status: Int
    var message: String
    var data: Profile?
}


// MARK: - DataClass
struct Profile: Codable {
    var userID, userName, email, password: String
    var userRole: String
    var profileImage: String
    var bio, userIdentify, userAgeGroup, notificationDisable, countryCode: String
    var diamondPoints, thunderPoints, created, verificationCode: String
    var verified, facebookToken, profileComplete, appleToken: String
    var authToken: String
    
    
    func getShortUserName()->String{
        let splitedUName = userName.split(separator: " ")
        return splitedUName.indices.contains(0) ? String(splitedUName[0]) : userName
    }
}
