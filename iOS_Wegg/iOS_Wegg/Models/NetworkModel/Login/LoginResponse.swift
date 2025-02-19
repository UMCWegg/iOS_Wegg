//
//  LoginResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

struct LoginResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
}

struct LoginResult: Decodable {
    let success: Bool
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case userID = "userId"
    }
}
