//
//  UserReason.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

// UserReason.swift 수정
enum UserReason: String, Codable {
    case formHabits = "HABIT_FORMATION"
    case followFriends = "FOLLOW_FRIENDS"
    case recordStudy = "RECORD_STUDY"
    case shareKnowledge = "SHARE_KNOWLEDGE"
    case other = "OTHER"
    
    var displayName: String {
        switch self {
        case .formHabits: return "공부 습관을 형성하기 위해서"
        case .followFriends: return "친구들을 따라서"
        case .recordStudy: return "공부를 기록하기 위해서"
        case .shareKnowledge: return "주변의 공부하기 좋은 장소를 찾기 위해서"
        case .other: return "직접 입력하기..."
        }
    }
    
    static var allCases: [String] {
        return [
            formHabits.displayName,
            followFriends.displayName,
            recordStudy.displayName,
            shareKnowledge.displayName,
            other.displayName
        ]
    }
    
    init?(from displayName: String) {
        switch displayName {
        case "공부 습관을 형성하기 위해서": self = .formHabits
        case "친구들을 따라서": self = .followFriends
        case "공부를 기록하기 위해서": self = .recordStudy
        case "주변의 공부하기 좋은 장소를 찾기 위해서": self = .shareKnowledge
        case "직접 입력하기...": self = .other
        default: return nil
        }
    }
}
