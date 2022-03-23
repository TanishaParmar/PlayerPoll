//
//  ListViewModal.swift
//  PlayerPoll
//
//  Created by mac on 19/10/21.
//

import UIKit


enum Categories: String,CaseIterable{
    case sports = "SPORTS"
    case entertainment = "ENTERTAINMENT"
    case relationships = "RELATIONSHIPS"
    case forFun = "FOR FUN"
    case society = "SOCIETY"
    case extra = "Extra"
    var color: UIColor{
        switch self {
        case .sports:
            return #colorLiteral(red: 0.001436090795, green: 0.2898610532, blue: 0.6811991334, alpha: 1)
        case .entertainment:
            return #colorLiteral(red: 0.7415030599, green: 0.0007053050213, blue: 0.4562799931, alpha: 1)
        case .relationships:
            return #colorLiteral(red: 0.5635025501, green: 0.001263548504, blue: 0, alpha: 1)
        case .forFun:
            return #colorLiteral(red: 0.8403177857, green: 0.2550058365, blue: 0.00191572425, alpha: 1)
        case .society, .extra:
            return #colorLiteral(red: 0.8099532723, green: 0.3675017655, blue: 0.9648931623, alpha: 1)
        }
    }
    
    var getID: String{
        switch self {
        case .sports:
            return "1"
        case .entertainment:
            return "2"
        case .relationships:
            return "3"
        case .forFun:
            return "4"
        case .society:
            return "5"
        case .extra:
            return "6"
        }
    }
}

extension String{
    
    func retrieveCategory()->Categories{
        switch self {
        case "SPORTS":
            return .sports
        case "ENTERTAINMENT":
            return .entertainment
        case "RELATIONSHIPS":
            return .relationships
        case "FOR FUN":
            return .forFun
        case "SOCIETY":
            return .society
        case "Extra":
            return .extra
        default:
            return .sports
        }
    }
    
    func getCategory()->Categories{
        switch self {
        case "1":
            return .sports
        case "2":
            return .entertainment
        case "3":
            return .relationships
        case "4":
            return .forFun
        case "5":
            return .society
        case "6":
            return .extra
        default:
            return .sports
        }
    }
}

struct ListViewData{
    var category: Categories
    var poll: String = ""
    
    func getReadStatusImage()->UIImage{
        if category == .sports{
            return UIImage(named: "unRead")!
        }
        return UIImage(named: "read")!
    }
}
