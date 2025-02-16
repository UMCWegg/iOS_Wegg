//
//  SignUpResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmptyResponse
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
}

struct SignUpResult: Decodable {
    let userId: Int
    let createdAt: String
    let contactFriends: [String]
}
