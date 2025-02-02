//
//  UserSignUpStorage.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.02.
//

import Foundation

final class UserSignUpStorage {
    static let shared = UserSignUpStorage()
    private let defaults = UserDefaults.standard
    private let storageKeys = StorageKeys.SignUp.self
    
    private init() {}
    
    struct SignUpData: Codable {
        var email: String?
        var password: String?
        var phoneNumber: String?
        var name: String?
        var nickname: String?
        var occupation: UserOccupation?
        var reason: UserReason?
        var marketingAgreed: Bool?
        var isAlertEnabled: Bool?
        var socialType: SocialType?
        var oauthID: String?
    }
    
    func save(_ data: SignUpData) {
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: storageKeys.signUpData)
        }
    }
    
    func get() -> SignUpData? {
        guard let data = defaults.data(forKey: storageKeys.signUpData),
              let signUpData = try? JSONDecoder().decode(SignUpData.self, from: data) else {
            return nil
        }
        return signUpData
    }
    
    func update(_ update: (inout SignUpData) -> Void) {
        var currentData = get() ?? SignUpData()
        update(&currentData)
        save(currentData)
    }
    
    func clear() {
        defaults.removeObject(forKey: storageKeys.signUpData)
    }
}
