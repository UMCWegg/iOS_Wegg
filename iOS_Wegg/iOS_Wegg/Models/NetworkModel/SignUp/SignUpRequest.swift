//
//  SignUpRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpRequest: Encodable {

    let email: String
    let password: String
    let marketingAgree: Bool
    let accountId: String
    let name: String
    let job: UserOccupation?
    let reason: UserReason?
    let phone: String
    let alarm: Bool
    let contact: [Contact]?
    let socialType: SocialType?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case marketingAgree
        case accountId
        case name
        case job
        case reason
        case phone
        case alarm
        case contact
        case socialType = "type"
        case accessToken = "token"
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
