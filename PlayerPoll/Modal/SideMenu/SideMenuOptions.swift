//
//  SideMenuOptions.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit


enum SideMenuOptions:String,CaseIterable{
    case notifications = "Notifications"
    case leaderboard = "Leaderboard"
    case listview = "List View"
    case messages = "Messages"
    case rewards = "Rewards"
    case settings = "Settings"
    case contact = "Contact"
    case superadmin = "Super Admin"
    
    var image: UIImage{
        switch self {
        case .notifications:
            return UIImage(named: "notifMenu")!
        case .leaderboard:
            return UIImage(named: "leaderboardMenu")!
        case .listview:
            return UIImage(named: "listViewMenu")!
        case .messages:
            return UIImage(named: "messagesMenu")!
        case .rewards:
            return UIImage(named: "rewardsMenu")!
        case .settings:
            return UIImage(named: "settingsMenu")!
        case .contact:
            return UIImage(named: "contactMenu")!
        case .superadmin:
            return UIImage(named: "superAdminMenu")!
        }
    }
    
}
