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
    
    // Token 관리
    func saveToken(_ token: String) {
        defaults.set(token, forKey: StorageKeys.Login.accessToken)
    }
    
    func getToken() -> String? {
        return defaults.string(forKey: StorageKeys.Login.accessToken)
    }
    
    // 소셜 로그인 데이터 관리
    func saveGoogleData(token: String, email: String) {
        defaults.set(token, forKey: "googleToken")
        defaults.set(email, forKey: "googleEmail")
    }
    
    func saveKakaoData(token: String, id: String) {
        defaults.set(token, forKey: "kakaoToken")
        defaults.set(id, forKey: "kakaoID")
    }
    
    // 데이터 초기화
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
    }
}
