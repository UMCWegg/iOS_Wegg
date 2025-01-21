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
}
