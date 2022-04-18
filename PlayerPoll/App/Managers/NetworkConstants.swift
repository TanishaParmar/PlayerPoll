//
//  NetworkConstants.swift
//  PlayerPoll
//
//  Created by mac on 01/11/21.
//

import Foundation


class Constant: NSObject {
    static let appBaseUrl = "https://signidapp.com/playerPoll/Api/" // live
//    static let appBaseUrl = "https://signidapp.com/playerPollStaging/Api/" //staging // "https://www.dharmani.com/playerPoll/Api/"
}

func getFinalUrl(with endPoint: NetworkConstants) -> String {
    //Base Url
    let baseUrl = Constant.appBaseUrl // "https://www.dharmani.com/playerPoll/Api/"
    return baseUrl+endPoint.rawValue
}


enum NetworkConstants: String {
    case login = "logIn"
    case appleLogin = "appleLogin"
    case facebookLogin = "facebookLogin"
    case signUp = "signUp"
    case forgetPassword = "forgetPassword"
    case changePwd = "changePassword"
    case identifier = "profileComplete"
    case getProfile = "getProfile"
    case notificationActivity = "notificationActivity"
    case logout = "logOut"
    case editProfile = "editProfile"
    case allBackgrounds = "getAllBackground"
    case allSponsors = "getAllSponsor"
    case addEditSponsor = "addEditSponsor"
    case addEditBackground = "addEditBackground"
    case superAdminPolls = "getAllPoll"
    case addEditPoll = "addEditPoll"
    case getUserPolls = "getAllPollByType"
    case getUserPolls2 = "getAllPollByTypev2"
    case submitPoll = "submitPoll"
    case getProfileById = "getProfileByUserID"
    case generateRoom = "createRoom"
    case getChatMessages = "getAllChatMessages"
    case sendMessage = "sendMessage"
    case getAnalytics = "getAllAnalytics"
    case getUsersMessagingList = "getAllChatUser"
    case getLeaderboard = "getAllUserLeaderboard"
    case updatePollView = "updatePollView"
    case getAllRewardsRequest = "getAllRewardsRequest"
    case updateRewardsRequest = "updateRewardsRequest"
    case submitRewardRequest = "submitRewardsRequest"
    case getAllAudio = "getAllAudio"
    case sendMassPush = "sendMassPush"
    case updateMessageSeen = "updateMessageSeen"
    case getUnreadTotalMessageCount = "getUnreadTotalMessageCount"
    case getAllCategory = "getAllCategory"
    case getAllCategoryv2 = "getAllCategoryv2"
    case addEditCategory = "addEditCategory"
    case addEditCategoryv2 = "addEditCategoryv2"
    case smartNotification = "sendSmartMassPush"
}
