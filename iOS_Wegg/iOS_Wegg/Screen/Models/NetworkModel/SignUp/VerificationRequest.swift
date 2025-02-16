//
//  VerificationRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.16.
//

struct SendPhoneVerificationRequest: Encodable {
    let phone: String
}

struct SendEmailVerificationRequest: Encodable {
    let email: String
}

struct CheckVerificationRequest: Encodable {
    let type: String
    let target: String
    let number: String
}
