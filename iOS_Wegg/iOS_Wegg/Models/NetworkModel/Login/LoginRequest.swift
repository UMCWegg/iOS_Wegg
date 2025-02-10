//
//  LoginRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginRequest: AuthRequest {
    let email: String?
    let password: String?
    let socialType: SocialType?
    let oauthID: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case socialType = "social_type"
        case oauthID = "oauth_id"
    }
}

struct VerificationResponse: Codable {
    let isSuccess: Bool
    let message: String
    let verificationID: String?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case message
        case verificationID = "verification_id"
    }
}
