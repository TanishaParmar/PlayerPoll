//
//  SuperAdminOptions.swift
//  PlayerPoll
//
//  Created by mac on 25/10/21.
//

import UIKit

enum SuperAdminOptions: String, CaseIterable{
    case createPoll = "Create Poll"
    case requests = "Requests"
    case analytics = "Analytics"
    case manageSponsors = "Manage Sponsors"
    case manageBackgrounds = "Manage Backgrounds"
    case support = "Support"
    case notifications = "Send a notification"
    case smartNotifications = "Send a Smart Notification"
    case categories = "Manage Categories"
}


//MARK:-  Backgrounds Listing
struct AllBackgroundsResponseModal: Codable {
    let status: Int
    let message: String
    let data: [Backgrounds]
}

struct Backgrounds: Codable {
    let bgID, catID, bgName: String
    let bgImage: String
    let created: String
}

//MARK:- Add Background

struct AddEditBackgroundResponse: Codable{
    let status: Int
    let message: String
}

//MARK: - Sponsors Listing
struct AllSponsorsResponseModal: Codable {
    let status: Int
    let message: String
    let data: [Sponsors]
}

struct Sponsors: Codable {
    let sponsorID, sponsorName: String
    let sponsorImage: String
    let created: String
}

//MARK:- Add Sponsor
struct AddSponsorResponse: Codable {
    let status: Int
    let message: String
}


//MARK:- Super Admin Polls

struct SuperAdminPollsResponseModal: Codable {
    let status: Int
    let message: String
    let data: [SuperAdminPolls]
}

// MARK: - Datum
struct SuperAdminPolls: Codable {
    let pID, userID, pollText, catID: String
    let bgID, sponsorID, points, created: String
    let pollOptions: [PollOption]
    
    func getCreationTime()->String{
        let timeStamp = created.toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
    func getCreationDate()->Date{
        let timeStamp = created.toIntVal()
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return date
    }
}

// MARK: - PollOption
struct PollOption: Codable {
    let optionID, pID, options, optionsCode: String
    let created: String
}


//MARK:- Options
struct Options{
    var oid: String
    var option: String
}


//MARK:- Create , Edit Poll Response
struct CreateEditPollResponse: Codable {
    let status: Int
    let message: String
}


//MARK:- Analytics

struct AnalyticsModalResponse: Codable {
    let status: Int
    let message: String
    let data: Analytics?
}

struct Analytics: Codable {
    let totalUsers, totalPoll, totalPollResponse, totalSponsor: String
    let totalSponsorPoll, totalPollView: String
    let totalUsersInPercentage: Int
    let totalPollResponseInAvg: String
}

struct AnalyticsDetails{
    var type: AnalyticsType
    var value: String
}

enum AnalyticsType: String{
    case users = "No. of users"
    case changeUsers = "% change in users over 30 days"
    case totalPolls = "Total polls"
    case totalPollResponses = "Total poll responses"
    case pollResponseAvg = "Average responses per poll"
    case sponsors = "Number of sponsors"
    case sponsoredPolls = "Number of sponsored polls"
    case totalPollViews = "Total poll views"
}



// MARK: - Rewards Listing

struct RewardsListingResponseModal: Codable {
    let status: Int
    let message: String
    let data: [Rewards]?
}

struct Rewards: Codable {
    let reqID, userID, mobileNo, paypal: String
    let venmo, upi, isPayment, rewardPoints: String
    let created, userName, totalRewardsPoints: String
    let rewardsHistry: [RewardsHistry]
}

// MARK: - RewardsHistry
struct RewardsHistry: Codable {
    let hisID, userID, rewardPoints, created: String
    let price: String
}


struct UpdateRewardResponseModal: Codable {
    let status: Int
    let message: String
    let data: Rewards?
}



//MARK:- Categories

struct CategoryDataResponseModal: Codable {
    let status: Int
    let message: String
    let data: [CategoryData]?
}

// MARK: - Datum
struct CategoryData: Codable {
    let catID: String
    let title: String
    let catImage: String
    let isDisable: String
    let catColor: String
    let audID: String
    let audID1: String?
    let audID2: String?
    let audID3: String?
    let created: String
    let audioDetails: [AudioDetail]?
    
    func getCatColor()->UIColor {
        if catColor.isEmpty {
            return #colorLiteral(red: 0.8099532723, green: 0.3675017655, blue: 0.9648931623, alpha: 1)
        }
        return UIColor(hexString: catColor)
    }
}

struct AudioDetail: Codable {
    var audID, catID: String?
    var audioFile: String?
    var audCode, created: String?
}

