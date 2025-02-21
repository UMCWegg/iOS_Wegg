//
//  SettingsUpdateRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//


//
//  SettingsUpdateRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import Foundation

struct SettingsUpdateRequest: Codable {
    // 알림 설정
    let postAlarm: Bool
    let commentAlarm: Bool
    
    let placeAlarm: String
    let randomAlarm: String
    let eggAlarm: String
    
    // 기능 설정
    let marketingAgree: Bool
    
    let placeCheck: Bool
    let randomCheck: Bool
    let breakAllow: Bool
    
    // 계정 공개 범위
    let accountVisibility: String

}
