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
    let contact: [Contact]?
    
    enum CodingKeys: String, CodingKey {
        case oauthId = "oauth_id"
        case email
        case password
        case marketingAgree = "marketing_agree"
        case accountId = "account_id"
        case name
        case job
        case reason
        case phone
        case alarm
        case contact
    }
}

struct SocialSignUpRequest: Codable {
    let email: String
    let name: String
    let accountId: String
    let marketingAgree: Bool
    let phone: String
    let alarm: Bool
    let job: String
    let reason: String
    let contact: [Contact]?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(marketingAgree, forKey: .marketingAgree)
        try container.encode(phone, forKey: .phone)
        try container.encode(alarm, forKey: .alarm)
        try container.encode(job, forKey: .job)
        try container.encode(reason, forKey: .reason)
        
        // contact가 비어있으면 null로 인코딩
        if let contact = contact, !contact.isEmpty {
            try container.encode(contact, forKey: .contact)
        }
    }
}
