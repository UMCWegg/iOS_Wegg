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
    
    public struct SignUpData: Codable {
        var email: String
        var password: String
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
        var accessToken: String?
        
        init(email: String = "",
             password: String = "",
             name: String? = nil,
             accountId: String? = nil,
             job: UserOccupation? = nil,
             reason: UserReason? = nil,
             phone: String? = nil,
             marketingAgree: Bool? = nil,
             alarm: Bool? = nil,
             contact: [Contact]? = nil,
             socialType: SocialType? = nil,
             accessToken: String? = nil) {
            self.email = email
            self.password = password
            self.name = name
            self.accountId = accountId
            self.job = job
            self.reason = reason
            self.phone = phone
            self.marketingAgree = marketingAgree
            self.alarm = alarm
            self.contact = contact
            self.socialType = socialType
            self.accessToken = accessToken
        }
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
            password: socialType == .email ? password : "-",
            marketingAgree: marketingAgree ?? false,
            accountId: accountId ?? "",
            name: name ?? "",
            job: job ?? UserOccupation.employee,
            reason: reason ?? UserReason.formHabits,
            phone: phone ?? "",
            alarm: alarm ?? false,
            contact: contact?.map { Contact(phone: $0.phone) } ?? nil,
            socialType: socialType == .email ? nil : socialType,
            accessToken: socialType == .email ? nil : accessToken
        )
    }
}
