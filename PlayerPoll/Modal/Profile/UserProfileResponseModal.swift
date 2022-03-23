//
//  UserProfileResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 30/11/21.
//

import Foundation


struct UserProfileResponseModal: Codable {
    let status: Int
    let message: String
    let data: UserProfile?
}

// MARK: - DataClass
struct UserProfile: Codable {
    let userID, userName, email, password, userRank: String
    let userRole: String
    let profileImage: String
    let bio, userIdentify, userAgeGroup, notificationDisable: String
    let diamondPoints, thunderPoints, created, verificationCode: String
    let verified, facebookToken, profileComplete, appleToken, countryCode: String
    let authToken: String
}


// MARK: - Unread COunt

struct MessageUnreadResponse: Codable {
    let status: Int
    let message, count: String
}
