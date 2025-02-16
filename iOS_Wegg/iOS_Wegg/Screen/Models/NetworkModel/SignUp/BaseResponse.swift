//
//  BaseResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

struct IDCheckResult: Codable {
    let message: String
    let duplicate: Bool
    
}

struct SendVerification: Codable {
    let message: String
}

struct CheckVerification: Codable {
    let valid: String
}
