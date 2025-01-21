//
//  SocialLoginResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct SocialLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let socialID: String
    let email: String?
    let nickname: String?
}
