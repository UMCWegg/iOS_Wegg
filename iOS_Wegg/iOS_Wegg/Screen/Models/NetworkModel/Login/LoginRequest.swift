//
//  LoginRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginRequest: Encodable {
    let email: String
    let password: String?
    let socialType: SocialType
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case socialType = "social_type"
        case accessToken = "access_token"
    }
}
