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
    
    var identifier: String? {
        switch type {
        case .google: return email
        case .kakao: return accessToken
        case .email: return email
        }
    }
}
