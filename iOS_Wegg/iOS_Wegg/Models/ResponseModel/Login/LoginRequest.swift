//
//  LoginRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginRequest: Codable {
    let type: SocialType
    let accessToken: String?
    let email: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "social_type"
        case accessToken = "access_token"
        case email
        case password
    }
}
