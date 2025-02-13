//
//  SignUpResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code = "code"
        case message = "message"
        case result = "result"
        
    }
}
