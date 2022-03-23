//
//  AppConstants.swift
//  Nodat
//
//  Created by apple on 30/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit


let kAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "PlayerPoll"
let kAppBundleIdentifier : String = Bundle.main.bundleIdentifier ?? String()

class KeyMessages{
    static let shared = KeyMessages()
    let kMsgOk = "OK"
    let kNoInternet = "There is no internet connection."
    let kEnterName = "Please enter username."
    let kValidUserName = "Username may only have alpha numeric characters and the special characters (.) (-) (_) and may not begin with special characters."
    let kEnterPhone = "Please enter phone number."
    let kEnterValidPhone = "Invalid Phone Number. Please enter a valid phone number."
    let kEnterFirstname = "Please enter first name."
    let kEnterLastname = "Please enter last name."
    let kEnterEmailPwd = "Please enter email and password."
    let kEnterEmail = "Please enter email address."
    let kEnterBio = "Please enter your bio."
    let kSelectIdentity = "Please select your identity."
    let kSelectAgeGroup = "Please select your age group."
    let kEnterEmailUName = "Please enter email address or user name."
    let kEnterUserName = "Please enter user name."
    let kEnterValidEmail = "Invalid email, Please try again."
    let kEnterConfirmEmail = "Please enter confirm email."
    let kEnterConfirmValidEmail = "Confirm email must match."
    let kEnterPassword = "Please enter password."
    let kEnterConfirmPassword = "Please enter confirm password."
    let kPasswordNotMatch = "Passwords does not matched."
    let kPasswordWeak = "Password must be atleast 6 characters in length."
    let kAgreeTerms = "Please agree to Terms and Privacy Policy."
    let kPickProfilePicture = "Please select a profile picture to continue."
    let kSelectCountry = "Please select country to continue."
    let kPickSponsorPicture = "Please select a sponsor picture to continue."
    let kPickBGPicture = "Please select a background picture to continue."
    let kEnterZip = "Please enter zip code."
    let kEnterValidZip = "Invalid zipcode. Please enter a correct 5 digit zipcode."
    let kLogout = "Are you sure you want to log out?"
    let kAcceptTerms = "Please read Terms & Conditions and accept for register new account."
    let kEnterEventName = "Please enter event name."
    let kEnterEventDate = "Please select event date."
    let kEnterTeeDate = "Please select event Tee time."
    let kEnterValidEventDate = "Please select a valid event date."
    let kEnterValidTeeDate = "Please select a valid Tee time."
    let kEnterEventLoc = "Please select event location."
    let kEnterGroupName = "Please enter group name."
    let kSelectGroupImage = "Please select group image to continue."
    let kEnterPlayerFName = "Please enter player first name."
    let kEnterSponsorName = "Please enter sponsor name."
    let kEnterBackgroundName = "Please enter background name"
    let kSelectBackgroundType = "Please select category type"
    let kEnterPollText = "Please enter poll text."
    let kEnterPollPoints = "Please enter poll points."
    let kEnterValidPollPoints = "Please enter valid poll points."
    let kSelectBackground = "Please select a background to continue."
    let kSelectCategory = "Please select a category to continue."
    let kSelectSponsor = "Please select a sponsor to continue."
    let kFillOutPollOptions = "Please fill out the poll options to continue."
    let kFillPollFields = "Please fill out all the options."
    let kFillAtleastOnePayment = "Please fill atleast one payment option."
    let kEnterPushText = "Please enter push notification text."
    let kEnterPollPushText = "Please select a poll for the smart notification."
    let kEnterCatName = "Please enter category name to continue."
    let kSelectCatColor = "Please select category color to continue."
    let kEnterCatSound = "Please enter category audio to continue."
    let kEnterOldPwd = "Please enter old password to continue."
    let kEnterNewPwd = "Please enter new password to continue."
    let kEnterConfNewPwd = "Please enter confirm new password to continue."
    let kPwdNotMatch = "New Password and Confirm New Password doesn't match."
}


struct DefaultKeys{
    static let deviceToken = "deviceToken"
    static let id = "userId"
    static let authToken = "authToken"
    static let role = "Role"
    static let detailsSubmitted = "detailsSubmitted"
    static let storedEmail = "storedEmail"
    static let storedPwd = "storedPwd"
}

enum LivePauseColors{
    case on
    case off
    var color: UIColor{
        switch self {
        case .on:
            return #colorLiteral(red: 0.06583034992, green: 0.7058719993, blue: 0.4570622444, alpha: 1)
        case .off:
            return #colorLiteral(red: 0.6701415777, green: 0.7091672421, blue: 0.774727881, alpha: 1)
        }
    }
}
