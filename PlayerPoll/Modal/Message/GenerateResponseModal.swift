//
//  GenerateResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 04/12/21.
//

import Foundation

//Generate Room Id
struct GenerateResponseModal: Codable {
    let status: Int
    let message: String
    let data: GenerateRoom?
}
struct GenerateRoom: Codable {
    let id, userID, otherUserID, roomID: String
    let created, userName, profileImage, lastMessage: String
    let messageCount: String
}


//MessagesListing

struct MessagesListingResponseModal: Codable {
    let status: Int
    let message: String
    let lastPage: Bool?
    let data: [MessagesListing]?
    let userDetails: UserDetails?
}

struct MessagesListing: Codable {
    let id, userID, roomID, message: String
    let readStatus, created, userName, profileImage: String
}

struct UserDetails: Codable {
    let userID, userName, email, password: String
    let userRole, profileImage, bio, userIdentify: String
    let userAgeGroup, notificationDisable, diamondPoints, thunderPoints: String
    let totalRewardsPoints, created, verificationCode, verified: String
    let facebookToken, profileComplete, userRank, appleToken: String
    let authToken: String
}



//Send Message Modal
struct SendMessageResponseModal: Codable {
    let status: Int
    let message: String
    let data: MessagesListing?
}

