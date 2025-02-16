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
    func saveGoogleData(email: String) {
        defaults.set(email, forKey: StorageKeys.Social.googleEmail)
    }
    
    func getGoogleData(email: String?) -> String? {
        let email = defaults.string(forKey: StorageKeys.Social.googleEmail)
        return email
    }
    
    // Kakao 데이터
    func saveKakaoData(email: String) {
        defaults.set(email, forKey: StorageKeys.Social.kakaoID)
    }
    
    func getKakaoData(email: String?) -> String? {
        let email = defaults.string(forKey: StorageKeys.Social.kakaoID)
        return email
    }
    
    // 데이터 초기화
    func clearAllData() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: domain)
    }
    
    func clearAuthTokens() {
        defaults.removeObject(forKey: StorageKeys.Social.googleToken)
        defaults.removeObject(forKey: StorageKeys.Social.kakaoToken)
    }
    
    // UserID 데이터
    func saveUserID(_ userID: Int) {
        defaults.set(userID, forKey: StorageKeys.Login.userID)
    }
    
    // UserID 조회 (Int64 타입)
    func getUserID() -> Int? {
        return defaults.object(forKey: StorageKeys.Login.userID) as? Int
    }
}
