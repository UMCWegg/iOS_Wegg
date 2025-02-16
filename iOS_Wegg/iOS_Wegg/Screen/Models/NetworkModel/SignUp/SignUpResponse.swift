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
    let result: SignUpResult
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
}

struct SignUpResult: Decodable {
    let userID: Int64
    let createdAt: String
    let contact: [Contact]?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case createdAt
        case contact = "contactFriends"
    }
}
