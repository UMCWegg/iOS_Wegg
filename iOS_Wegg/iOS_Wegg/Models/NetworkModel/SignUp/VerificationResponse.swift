//
//  VerificationResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

struct VerificationResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultMessage
    
    struct ResultMessage: Codable {
        let message: String
    }
}
