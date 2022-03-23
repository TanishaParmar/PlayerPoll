//
//  AppleDataStoreManager.swift
//  PlayerPoll
//
//  Created by mac on 07/12/21.
//

import Foundation


class AppleDataStoreManager{
    
    static let shared = AppleDataStoreManager()
    
    func saveAppleDetailsToDefaults(details: AppleLoginDetails){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(details) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "savedAppleDetails")
        }
    }
    
    func retreiveAppleDetails(completion: @escaping (AppleLoginDetails)->Void, failure: @escaping()->Void){
        let defaults = UserDefaults.standard
        if let savedDetails = defaults.object(forKey: "savedAppleDetails") as? Data {
            let decoder = JSONDecoder()
            if let loadedDetails = try? decoder.decode(AppleLoginDetails.self, from: savedDetails) {
                completion(loadedDetails)
            }else{
                failure()
            }
        }else{
            failure()
        }
    }
}
