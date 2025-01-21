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
    let job: String?
    let reason: String?
    let contacts: [Contact]
    let alarm: Bool
}

enum SocialType: String, Codable {
    case naver
    case kakao
}

struct Contact: Codable {
    let name: String
    let phoneNumber: String
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
