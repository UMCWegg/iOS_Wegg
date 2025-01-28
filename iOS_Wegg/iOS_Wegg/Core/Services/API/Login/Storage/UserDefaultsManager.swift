//
//  UserDefaultsManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

final class UserDefaultsManager {
   static let shared = UserDefaultsManager()
   private let defaults = UserDefaults.standard
   
   private enum Keys {
       static let accessToken = "accessToken"
       static let refreshToken = "refreshToken"
       static let googleToken = "googleToken"
       static let googleEmail = "googleEmail"
       static let kakaoToken = "kakaoToken"
       static let kakaoId = "kakaoId"
    }
    
    func saveToken(_ token: String) {
        defaults.setValue(token, forKey: Keys.accessToken)
    }
    
    func getToken() -> String? {
        return defaults.string(forKey: Keys.accessToken)
    }
   
    func saveGoogleData(token: String, email: String) {
        defaults.setValue(token, forKey: Keys.googleToken)
        defaults.setValue(email, forKey: Keys.googleEmail)
    }
    
    func getGoogleData() -> (token: String?, email: String?) {
        let token = defaults.string(forKey: Keys.googleToken)
        let email = defaults.string(forKey: Keys.googleEmail)
        return (token, email)
    }
    
    func saveKakaoData(token: String, id: String) {
        defaults.setValue(token, forKey: Keys.kakaoToken)
        defaults.setValue(id, forKey: Keys.kakaoId)
    }
    
    func getKakaoData() -> (token: String?, id: String?) {
        let token = defaults.string(forKey: Keys.kakaoToken)
        let id = defaults.string(forKey: Keys.kakaoId)
        return (token, id)
    }
    
    func clearAuthData() {
        defaults.removeObject(forKey: Keys.googleToken)
        defaults.removeObject(forKey: Keys.googleEmail)
        defaults.removeObject(forKey: Keys.kakaoToken)
        defaults.removeObject(forKey: Keys.kakaoId)
    }
    
}
