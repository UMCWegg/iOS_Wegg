//
//  LoginResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let oauthID: String?
    let email: String?
    let type: SocialType
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case oauthID = "oauth_id"
        case email
        case type = "social_type"
    }
}
