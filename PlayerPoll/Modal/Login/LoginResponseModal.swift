//
//  LoginResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 01/11/21.
//

import Foundation


// MARK: - Welcome


struct LoginResponseModal: Codable {
    let status: Int
    let message: String
    let data: LoginData?
}

struct LoginData: Codable {
    let userID, userName, email, password: String
    let userRole, profileImage, bio, userIdentify: String
    let userAgeGroup, notificationDisable, created, verificationCode: String
    let verified, facebookToken, profileComplete, appleToken: String
    let authToken: String
}


struct AppleLoginDetails: Codable{
    var name: String
    var appleId: String
    var email: String
}
