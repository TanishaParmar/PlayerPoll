//
//  UserChatsResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 06/12/21.
//

import Foundation

struct UserChatsResponseModal: Codable {
    let status: Int
    let message: String
    let lastPage: Bool?
    let data: [UserChats]?
}

// MARK: - Datum
struct UserChats: Codable {
    let id, userID, otherUserID, roomID: String
    let created: String
    let profileImage: String
    let userName, lastMessage, lastMessageTime, messageCount: String
}
