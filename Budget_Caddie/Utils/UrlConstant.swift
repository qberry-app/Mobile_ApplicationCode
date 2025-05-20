//
//  APIList.swift
//  Budget_Caddie
//
//  Created by Sabin on 16/01/25.
//

import Foundation

struct Config {
    static var sharedInstance = Config()
    // Development Server url
    let baseURL = "http://98.85.169.103:8082/budgetCandy/"
    //  Testing Server url
//    let baseURL = "http://44.224.239.221:7001/pixlyGateway"
    //    Production
//        let baseURL = "http://44.241.33.220/gateway/pixlyGateway"
}

class UrlConstant {
    static let shared = UrlConstant()
    
    // Login API's
    let login = Config.sharedInstance.baseURL + "user/login"
    let signup = Config.sharedInstance.baseURL + "user/signup"
    let forgetPassword = Config.sharedInstance.baseURL + "user/forget/password"
    let otpValidation = Config.sharedInstance.baseURL + "user/validate/otp"
    let changePassword = Config.sharedInstance.baseURL + "user/update/forgetPassword"
    let saveOnBoardingDetails = Config.sharedInstance.baseURL + "user/save/onBoarding/details"
    let saveUserImage_Name = Config.sharedInstance.baseURL + "user/save/profileDetails"
    let checkUserNameAvailability = Config.sharedInstance.baseURL + "user/search/userName"
    let getOnboardingDetails = Config.sharedInstance.baseURL + "user/get/onBoarding/details"
    let saveUserSubscription = Config.sharedInstance.baseURL + "user/save/subscription"
    let getUserDetails = Config.sharedInstance.baseURL + "user/details"
    
    // Plaid Api's
    let generatePlaidToken = Config.sharedInstance.baseURL + "plaid/link/token"
    let plaidAccountDetails = Config.sharedInstance.baseURL + "plaid/user/account/details"
    let plaidSaveAccountDetails = Config.sharedInstance.baseURL + "plaid/save/account/details"
    //Goal Api's
    let createGoal = Config.sharedInstance.baseURL + "goal/create"
    let searchGoal = Config.sharedInstance.baseURL + "goal/search"
    let editGoal = Config.sharedInstance.baseURL + "goal/edit"
    let fetchGoal = Config.sharedInstance.baseURL + "goal/fetchAll"
    
    // Transaction
    let addManualTransaction = Config.sharedInstance.baseURL + "plaid/add/manual/transaction"
    let getTransactionsList = Config.sharedInstance.baseURL + "plaid/getTransaction/details"
}
