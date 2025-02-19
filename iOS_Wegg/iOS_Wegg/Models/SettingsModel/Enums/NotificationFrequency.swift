//
//  NotificationFrequency.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

enum NotificationFrequency: String, Codable {
    case single = "SINGLE"
    case continuous = "CONTINUOUS"
    
    var displayName: String {
        switch self {
        case .single: return "단발"
        case .continuous: return "연속"
        }
    }
}
