//
//  LoginApiModel.swift
//  Budget_Caddie
//
//  Created by Sabin on 16/01/25.
//

import Foundation
import ObjectMapper
import Alamofire

struct LoginApiModel: Decodable {
    let data: [String]?
    let status: String?
}


struct OTPValidationModel: Codable {
    let data: [OTPValidationModelData]?
    let status: String?
}

// MARK: - Datum
struct OTPValidationModelData: Codable {
    let status, message: String?
}

struct UserDetailsApiModel: Codable {
    let data: [UserDetailsApiModelUserDetails]?
    let status: String
}

struct UserDetailsApiModelUserDetails: Codable {
    let userName: String?
    let name: String?
    let email: String?
    let countryCode: String?
    let phoneNumber: String?
    let profilePictureUrl: String?
    let referralCode: String?
    let hasActiveSubscription: Bool?

    enum CodingKeys: String, CodingKey {
        case userName
        case name
        case email
        case countryCode
        case phoneNumber
        case profilePictureUrl
        case referralCode
        case hasActiveSubscription
    }
}
struct OnboardingDetailsModel: Codable {
    let data: [OnboardingDetailsModelData]?
    let status: String
}

struct OnboardingDetailsModelData: Codable {
    let howYouHear: String?
    let home: String?
    let userDebt: String?
    let userGetAround: String?
    let userSubscriptions: String?
    let userAnnualIncome: String?
    let userMajorSavings: String?
    let feelAboutFinance: String?
}


struct GoalListDetails: Codable {
    let data: [GoalListDataModel]?
    let status: String?
}

// MARK: - Datum
struct GoalListDataModel: Codable {
    let goalName: String?
    let currentAmount, desiredAmount: Int?
    let completedDate: String?
}
