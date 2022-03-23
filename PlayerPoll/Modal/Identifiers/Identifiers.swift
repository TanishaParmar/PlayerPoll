//
//  Identifiers.swift
//  PlayerPoll
//
//  Created by mac on 16/10/21.
//

import Foundation


enum Gender: String{
    case she = "She/Her/Hers"
    case he = "He/Him/His"
    case them = "They/Them/Theirs"
    var apiVal: String{
        switch self {
        case .she:
            return "1"
        case .he:
            return "2"
        case .them:
            return "3"
        }
    }
}

struct GenderIdentifier{
    var type: Gender
    var selected: Bool = false
}


enum Age {
    case babyBoomer
    case genX
    case millenial
    case genZ
    var apiVal: String{
        switch self {
        case .babyBoomer:
            return "1"
        case .genX:
            return "2"
        case .millenial:
            return "3"
        case .genZ:
            return "4"
        }
    }
    var titleVal: String {
        switch self {
        case .babyBoomer:
            return "Baby Boomer"
        case .genX:
            return "Gen X"
        case .millenial:
            return "Millenial"
        case .genZ:
            return "Gen Z"
        }
    }
    var ageVal: String{
        switch self {
        case .babyBoomer:
            return "57-65"
        case .genX:
            return "41-56"
        case .millenial:
            return "25-40"
        case .genZ:
            return "13-24"
        }
    }
}

struct AgeIdentifiers{
    var type: Age
    var selected: Bool = false
}
