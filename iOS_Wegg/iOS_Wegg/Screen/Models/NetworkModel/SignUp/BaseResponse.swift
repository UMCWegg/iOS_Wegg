//
//  BaseResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

struct BaseResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

struct IDCheckResult: Decodable {
    let message: String
    let duplicate: Bool
    
}

struct SendVerification: Decodable {
    let message: String
}

struct CheckVerification: Decodable {
    let valid: String
}
