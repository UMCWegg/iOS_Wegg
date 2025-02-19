//
//  NotificationType.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

enum NotificationType: String, Codable {
    case silent = "SILENT"
    case vibrate = "VIBRATE"
    case sound = "SOUND"
    case both = "BOTH"
    
    var displayName: String {
        switch self {
        case .silent: return "무음"
        case .vibrate: return "진동"
        case .sound: return "소리"
        case .both: return "진동+소리"
        }
    }
    
    var isActive: Bool {
        self != .silent
    }
}
