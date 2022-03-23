//
//  LeaderboardResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 08/12/21.
//

import Foundation

struct LeaderboardResponseModal: Codable {
    let status: Int
    let message: String
    let lastPage: Bool?
    let data: [Leaderboard]?
}

// MARK: - Datum
struct Leaderboard: Codable {
    let userID, userName, email, password: String
    let userRole: String
    let profileImage: String
    let bio, userIdentify, userAgeGroup, notificationDisable: String
    let diamondPoints, thunderPoints, totalRewardsPoints, created: String
    let verificationCode, verified, facebookToken, profileComplete: String
    let userRank, appleToken, authToken: String
}

