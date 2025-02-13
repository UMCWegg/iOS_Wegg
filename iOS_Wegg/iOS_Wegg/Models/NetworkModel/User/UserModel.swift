//
//  UserModel.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

// Base Data

struct BaseUser: Codable {
    let name: String
    let marketingAgree: Bool
    let accountID: String
    let occupation: UserOccupation?
    let reason: UserReason?
    let contact: [Contact]
    let alert: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case marketingAgree = "marketing_agree"
        case accountID = "account_id"
        case occupation
        case reason
        case contact = "contact"
        case alert
    }
}

enum SocialType: String, Codable {
    case google
    case kakao
    case email
}

struct Contact: Codable {
    let phone: String
}

// Divided with Cases

struct SocialUser: Codable {
    let user: BaseUser
    let oauthID: String
    let socialType: SocialType
}

struct EmailUser: Codable {
    let user: BaseUser
    let email: String
    let password: String
}

struct UserUpdateRequest: Codable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address
    }
}
