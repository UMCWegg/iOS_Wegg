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
}
