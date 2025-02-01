//
//  SignUpRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpRequest: Codable {
    let email: String?
    let password: String?
    let socialType: SocialType?
    let oauthToken: String?
    let name: String
    let nickname: String
    let phoneNumber: String
    let occupation: UserOccupation
    let reason: UserReason
    let marketingAgreed: Bool
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case socialType = "social_type"
        case oauthToken = "oauth_token"
        case name
        case nickname
        case phoneNumber = "phone_number"
        case occupation = "occupation"
        case reason
        case marketingAgreed = "marketing_agreed"
    }
}
