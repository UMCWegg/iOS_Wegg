//
//  SignUpRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpRequest: Codable {
    // 소셜 로그인용
    let oauthId: String?
    
    // 이메일 로그인용
    let email: String?
    let password: String?
    
    // 공통 필드
    let marketingAgree: Bool
    let accountId: String
    let name: String
    let job: String
    let reason: String
    let phone: String
    let alarm: Bool
    let contact: [Contact]
    
    enum CodingKeys: String, CodingKey {
        case oauthId
        case email
        case password
        case marketingAgree
        case accountId
        case name
        case job
        case reason
        case phone
        case alarm
        case contact
    }
}
