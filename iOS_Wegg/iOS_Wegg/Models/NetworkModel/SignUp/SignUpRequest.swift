//
//  SignUpRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.10.
//

import Foundation

struct SignUpRequest: AuthRequest {
    let email: String?
    let password: String?
    let socialType: SocialType?
    let oauthID: String?
    let name: String
    let nickname: String
    let phoneNumber: String
    let occupation: UserOccupation
    let reason: UserReason
    let marketingAgreed: Bool
    let contact: [Contact]
    let alert: Bool
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case socialType = "social_type"
        case oauthID = "oauth_id"
        case name
        case nickname
        case phoneNumber = "phone_number"
        case occupation
        case reason
        case marketingAgreed = "marketing_agree"
        case contact
        case alert
    }
}
