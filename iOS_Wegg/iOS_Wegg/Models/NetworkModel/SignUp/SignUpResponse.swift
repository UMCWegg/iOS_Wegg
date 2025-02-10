//
//  SignUpResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.10.
//

import Foundation

struct SignUpResponse: AuthResponse {
    let accessToken: String
    let refreshToken: String?
    let user: BaseUser
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}
