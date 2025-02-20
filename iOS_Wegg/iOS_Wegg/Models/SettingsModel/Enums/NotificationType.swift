//
//  NotificationType.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//


enum NotificationType: String, Codable {
    case mute = "MUTE"
    case vibrate = "VIBRATE"
    case sound = "SOUND"
    case both = "BOTH"
    
    // 단발/연속 버전 추가
    case muteSingle = "MUTE_SINGLE"
    case vibrateSingle = "VIBRATE_SINGLE"
    case soundSingle = "SOUND_SINGLE"
    case bothSingle = "BOTH_SINGLE"
    
    case muteContinuous = "MUTE_CONTINUOUS"
    case vibrateContinuous = "VIBRATE_CONTINUOUS"
    case soundContinuous = "SOUND_CONTINUOUS"
    case bothContinuous = "BOTH_CONTINUOUS"
    
    var displayName: String {
        switch self {
        case .mute, .muteSingle, .muteContinuous: return "무음"
        case .vibrate, .vibrateSingle, .vibrateContinuous: return "진동"
        case .sound, .soundSingle, .soundContinuous: return "소리"
        case .both, .bothSingle, .bothContinuous: return "진동+소리"
        }
    }
    
    var isMute: Bool {
        return self == .mute || self == .muteSingle || self == .muteContinuous
    }
    
    var isContinuous: Bool {
        return self == .muteContinuous || self == .vibrateContinuous ||
               self == .soundContinuous || self == .bothContinuous
    }
    
    static func fromString(_ value: String) -> NotificationType {
        switch value {
        case "MUTE_SINGLE": return .muteSingle
        case "VIBRATE_SINGLE": return .vibrateSingle
        case "SOUND_SINGLE": return .soundSingle
        case "BOTH_SINGLE": return .bothSingle
        case "MUTE_CONTINUOUS": return .muteContinuous
        case "VIBRATE_CONTINUOUS": return .vibrateContinuous
        case "SOUND_CONTINUOUS": return .soundContinuous
        case "BOTH_CONTINUOUS": return .bothContinuous
        default: return .soundSingle
        }
    }
}
