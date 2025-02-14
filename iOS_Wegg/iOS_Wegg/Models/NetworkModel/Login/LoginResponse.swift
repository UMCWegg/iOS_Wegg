//
//  LoginResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginResponse: Codable {
    let email: String?
    let type: SocialType
    
    enum CodingKeys: String, CodingKey {
        case email
        case type = "social_type"
    }
}
