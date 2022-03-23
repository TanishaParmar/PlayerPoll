//
//  DateFormatterManager.swift
//  PlayerPoll
//
//  Created by mac on 14/12/21.
//

import Foundation

class DateFormatterManager{
    
    static let shared = DateFormatterManager()
    
    private init(){
        
    }
    
    func checkAndReturnDate(date: Date)->String{
        Calendar.current.component(.day, from: date) == Calendar.current.component(.day, from: Date()) ? returnFormatter(with: "hh:mm a").string(from: date) : (Calendar.current.component(.year, from: date) == Calendar.current.component(.year, from: Date()) ? returnFormatter(with: "dd MMM hh:mm a").string(from: date) : returnFormatter(with: "MMM dd yyyy hh:mm a").string(from: date))
    }
    
    func returnFormatter(with format: String)->DateFormatter{
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter
    }
    
    func getDate(from stamp: String)->Date{
        let timeStamp = stamp.toIntVal()
        return Date(timeIntervalSince1970: TimeInterval(timeStamp))
    }
    
    func getStringDateFormat(format: String, stamp: String)->String{
        let date = self.getDate(from: stamp)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
