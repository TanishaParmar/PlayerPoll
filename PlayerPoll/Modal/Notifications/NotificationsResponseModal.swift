//
//  NotificationsResponseModal.swift
//  PlayerPoll
//
//  Created by mac on 15/11/21.
//

import Foundation


// MARK: - NotificationResponseModel
struct NotificationResponseModel: Codable {
    let status: Int
    let message: String
    let lastPage: Bool?
    let data: [Notifications]?
    let count: String
}

// MARK: - Datum
struct Notifications: Codable {
    let notificationID, title, datumDescription, notificationType: String
    let userID, otherUserID, roomID, detailsID: String
    let notificationReadStatus, created: String
    let profileImage: String
    let userName: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case title
        case datumDescription = "description"
        case notificationType = "notification_type"
        case userID, otherUserID, roomID, detailsID
        case notificationReadStatus = "notification_read_status"
        case created, profileImage, userName
    }
    
    func getCreationTime()->String{
        let timeStamp = (created).toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
    func getNotifImage()->String{
        switch notificationType {
        case "1":
            return "notification"
        case "2":
            return "message"
        case "4":
            return "notification"
        default:
            return ""
        }
    }
    
    func getNotifType()->NotificationType{
        switch notificationType{
        case "2":
            return .chat
        case "4":
            return .smart
        default:
            return .mass
        }
    }
}

enum NotificationType{
    case chat
    case mass
    case smart
}
