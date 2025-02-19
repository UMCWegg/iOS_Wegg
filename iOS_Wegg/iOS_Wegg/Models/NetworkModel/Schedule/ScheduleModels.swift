//
//  ScheduleModels.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct CookieStorage {
    static let cookie: String = "28B5EBCFB902182C74E36C7E692429DE"
}

/// 일정 상태를 나타내는 Enum
enum ScheduleStatus: String, Encodable {
    case yet = "YET"
    case done = "DONE"
}

// 지각 상태 Enum
enum LateStatus: String, Codable {
    case onTime = "ZERO"      // 정시 도착
    case late3Min = "THREE"    // 3분 지각
    case late5Min = "FIVE"     // 5분 지각
    case late7Min = "SEVEN"    // 7분 지각
    case late10Min = "TEN"     // 10분 지각
}
