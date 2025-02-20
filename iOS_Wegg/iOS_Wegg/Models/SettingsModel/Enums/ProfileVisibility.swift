//
//  ProfileVisibility.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

enum ProfileVisibility: String, Codable {
    case all = "ALL"
    case mutual = "FOLLOWER_ONLY"
    
    var displayName: String {
        switch self {
        case .all: return "전체 공개"
        case .mutual: return "맞팔만 공개"
        }
    }
    
    static func fromString(_ value: String) -> ProfileVisibility {
        switch value {
        case "ALL": return .all
        case "FOLLOWER_ONLY": return .mutual
        default: return .mutual
        }
    }
}
