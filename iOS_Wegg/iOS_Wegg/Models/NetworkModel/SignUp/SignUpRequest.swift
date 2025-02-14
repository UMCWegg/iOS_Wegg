//
//  SignUpRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpRequest: Codable {

    let email: String?
    let password: String?
    let marketingAgree: Bool
    let accountId: String
    let name: String
    let job: String
    let reason: String
    let phone: String
    let alarm: Bool
    let contact: [Contact]?
    
    enum CodingKeys: String, CodingKey {
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
