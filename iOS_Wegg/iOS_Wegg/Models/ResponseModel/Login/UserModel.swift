//
//  UserModel.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct UserModel: Codable {
    let id: Int
    let email: String?
    let nickname: String?
    let socialType: SocialType
    let socialID: String
}

enum SocialType: String, Codable {
    case naver
    case kakao
    case email
}
