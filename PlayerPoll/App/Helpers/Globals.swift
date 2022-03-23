//
//  Globals.swift
//  PlayerPoll
//
//  Created by mac on 01/11/21.
//

import Foundation

struct Globals{

    static let defaults = UserDefaults.standard
    
    static var authToken: String{
      return defaults.value(forKey: DefaultKeys.authToken) as? String ?? "uid"
    }
    
    static var userId: String{
      return defaults.value(forKey: DefaultKeys.id) as? String ?? "uid"
    }
    
    static var deviceToken: String{
        return defaults.value(forKey: DefaultKeys.deviceToken) as? String ?? "529173FB75AC135EE09EE7186B98C89DBC72C2CC0EF25C242EA7DA31BD292EFCD"
    }
    
    static var superAdminId: String{
        return "41"
    }
    
    static var detailsSubmitted: Bool{
        return defaults.value(forKey: DefaultKeys.detailsSubmitted) as? Bool ?? true
    }
    
    
    static func getStoredEmailPwd()->(String,String){
        let email = defaults.value(forKey: DefaultKeys.storedEmail) as? String ?? ""
        let passwrd = defaults.value(forKey: DefaultKeys.storedPwd) as? String ?? ""
        return (email,passwrd)
    }
    
    
    func getCountryData(completion: @escaping(([FlagDetails])->Void)){
        var flagsArray:[FlagDetails] = []
        let bundle = Bundle.main
        let path = bundle.path(forResource: "countriesList", ofType: "json")
        let  info = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data = info!.data(using: String.Encoding.utf8)
        let json: AnyObject? = try? JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
        flagsArray.removeAll()
        if let j: AnyObject = json {
            if let flagArray = j as? [[String:Any]]{
                let res = flagArray.map({FlagDetails(countryCode: $0["code"] as? String ?? "", imageName: $0["nameImage"] as? String ?? "", countryName: $0["name"] as? String ?? "")})
                completion(res)
            }
        }
    }
    
}
