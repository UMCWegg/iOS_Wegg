//
//  VerificationRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.16.
//

struct SendPhoneVerificationRequest: Codable {
    let phone: String
}

struct SendEmailVerificationRequest: Codable {
    let email: String
}

struct CheckVerificationRequest: Codable {
    let type: String
    let target: String
    let number: String
}
