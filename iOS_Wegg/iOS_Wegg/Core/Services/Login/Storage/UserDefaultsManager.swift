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
       static let naverToken = "naverToken"
       static let naverId = "naverId"
       static let kakaoToken = "kakaoToken"
       static let kakaoId = "kakaoId"
   }
   
   func saveNaverToken(token: String, id: String) {
       defaults.setValue(token, forKey: Keys.naverToken)
       defaults.setValue(id, forKey: Keys.naverId)
   }
   
   func getNaverToken() -> (token: String?, id: String?) {
       let token = defaults.string(forKey: Keys.naverToken)
       let id = defaults.string(forKey: Keys.naverId)
       return (token, id)
   }
   
   func clearNaverData() {
       defaults.removeObject(forKey: Keys.naverToken)
       defaults.removeObject(forKey: Keys.naverId)
   }
}
