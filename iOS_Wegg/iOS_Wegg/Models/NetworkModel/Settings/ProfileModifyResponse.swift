//
//  ProfileModifyResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

struct ProfileModifyResponse: Codable {
    let success: Bool
    let updateFields: UpdateFields
}

struct UpdateFields: Codable {
    let name: String
    let accountID: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case accountID = "accountId"
        case profileImage
    }
}
