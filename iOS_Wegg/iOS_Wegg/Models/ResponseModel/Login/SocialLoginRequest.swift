//
//  SocialLoginRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct SocialLoginRequest: Codable {
    let socialType: SocialType
    let accessToken: String
    let socialID: String
}
