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
        var name: String?
        var accountId: String?
        var job: UserOccupation? 
        var reason: UserReason?
        var phone: String?
        var marketingAgree: Bool?
        var alarm: Bool?
        var contact: [Contact]?
        
        // 소셜 로그인 구분용
        var socialType: SocialType?
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

extension UserSignUpStorage.SignUpData {
    func toSignUpRequest() -> SignUpRequest {
        
        return SignUpRequest(
            email: email,
            password: socialType == .email ? password : nil,
            marketingAgree: marketingAgree ?? false,
            accountId: accountId ?? "",
            name: name ?? "",
            job: job ?? UserOccupation.employee,
            reason: reason ?? UserReason.formHabits,
            phone: phone ?? "",
            alarm: alarm ?? false,
            contact: contact?.map { Contact(phone: $0.phone) } ?? []
        )
    }
}
