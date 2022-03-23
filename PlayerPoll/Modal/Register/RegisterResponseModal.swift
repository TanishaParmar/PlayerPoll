//
//  RegisterResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 02/11/21.
//

import Foundation

struct RegisterResponseModal: Codable {
    let status: Int
    let message: String
    let data: RegisterData?
}

// MARK: - DataClass
struct RegisterData: Codable {
    let userID, userName, email, password: String
    let userRole, profileImage, bio, userIdentify: String
    let userAgeGroup, notificationDisable, created, verificationCode: String
    let verified, facebookToken, profileComplete, appleToken: String
    let authToken: String
}

struct FlagDetails{
    var countryCode: String
    var imageName: String
    var countryName: String
    var selected:Bool = false
}
