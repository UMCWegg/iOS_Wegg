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
    
    private init() {}
    
    // Google 데이터
    func saveGoogleData(token: String, email: String) {
        defaults.set(token, forKey: StorageKeys.Social.googleToken)
        defaults.set(email, forKey: StorageKeys.Social.googleEmail)
    }
    
    func getGoogleData() -> (token: String?, email: String?) {
        let token = defaults.string(forKey: StorageKeys.Social.googleToken)
        let email = defaults.string(forKey: StorageKeys.Social.googleEmail)
        return (token, email)
    }
    
    // Kakao 데이터
    func saveKakaoData(token: String, id: String) {
        defaults.set(token, forKey: StorageKeys.Social.kakaoToken)
        defaults.set(id, forKey: StorageKeys.Social.kakaoID)
    }
    
    func getKakaoData() -> (token: String?, id: String?) {
        let token = defaults.string(forKey: StorageKeys.Social.kakaoToken)
        let id = defaults.string(forKey: StorageKeys.Social.kakaoID)
        return (token, id)
    }
    
    // 데이터 초기화
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier
        defaults.removePersistentDomain(forName: domain)
    }
}
