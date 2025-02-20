//
//  SettingsModel.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

struct SettingModel: Codable {
    // 프로필 정보
    var name: String
    var accountId: String
    var profileIMageURL: String?
    
    // 알림 설정
    
    var isFriendsNotificationEnabled: Bool
    var isCommentNotificationEnabled: Bool
    
    var locationNotification: NotificationSetting
    var randomNotification: NotificationSetting
    var breakEggNotification: NotificationSetting
    
    // 기능 설정
    var features: FeatureSettings
    
    // 계정 공개 범위
    var visibility: ProfileVisibility
}
