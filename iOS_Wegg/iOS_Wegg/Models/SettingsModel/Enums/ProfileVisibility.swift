//
//  ProfileVisibility.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

enum ProfileVisibility: String, Codable {
    case all = "ALL"
    case mutual = "MUTUAL"
    
    var displayName: String {
        switch self {
        case .all: return "전체 공개"
        case .mutual: return "맞팔만 공개"
        }
    }
}
