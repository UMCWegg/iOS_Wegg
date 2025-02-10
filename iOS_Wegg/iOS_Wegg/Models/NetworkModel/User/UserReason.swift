//
//  UserReason.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

enum UserReason: String, Codable {
    case formHabits = "공부 습관을 형성하기 위해서"
    case followFriends = "친구들을 따라서"
    case recordStudy = "공부를 기록하기 위해서"
    case shareKnowledge = "주변의 공부하기 좋은 장소를 찾기 위해서"
    case other = "직접 입력하기..."
    
    static var allCases: [String] {
        return [
            formHabits.rawValue,
            followFriends.rawValue,
            recordStudy.rawValue,
            shareKnowledge.rawValue,
            other.rawValue
        ]
    }
    
    init?(from: String) {
        self.init(rawValue: from)
    }
}
