//
//  HomePolls.swift
//  PlayerPoll
//
//  Created by mac on 20/10/21.
//

import Foundation



struct PollsModal{
    var pollQuestion: String
    var answers: [PollAnswers]
    var currentUserAnswered: Bool
}

struct PollAnswers{
    var answer: String
    var perc: String
    var selected: Bool = false
}


struct PollSubmissionResponseModal: Codable {
    let status: Int
    let message: String
    let data: HomePolls?
}


struct RecordPollViewResponseModal: Codable {
    let status: Int
    let message: String
}
