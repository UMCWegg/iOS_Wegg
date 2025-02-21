//
//  SettingsUpdateResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import Foundation

struct SettingsUpdateResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
}
