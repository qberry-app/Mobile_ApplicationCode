//
//  UserDefaultsHandler.swift
//  Budget_Caddie
//
//  Created by Sabin on 02/02/25.
//

import Foundation

class UserDefaultsHandler: NSObject {
    static let shared = UserDefaultsHandler()
    
    func setUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.synchronize()
    }
    func getUserEmail() -> String? {
        return Utils.shared.checkNullvalue(passedValue: UserDefaults.standard.string(forKey: "userEmail"))
    }
    func setUserPassword(_ password: String) {
        UserDefaults.standard.set(password, forKey: "userPassword")
        UserDefaults.standard.synchronize()
    }
    func getUserPassword() -> String? {
        return Utils.shared.checkNullvalue(passedValue: UserDefaults.standard.string(forKey: "userPassword"))
    }
    func setCurrentDeviceToken(token: String) {
        UserDefaults.standard.set(token, forKey: "currentDeviceToken")
        UserDefaults.standard.synchronize()
    }
    func getCurrentDeviceToken()-> String {
        return Utils.shared.checkNullvalue(passedValue: UserDefaults.standard.string(forKey: "currentDeviceToken"))
    }
}
