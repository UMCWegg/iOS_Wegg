//
//  SettingsStorage.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import Foundation

final class SettingsStorage {
    static let shared = SettingsStorage()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // 키 값들 열거형으로 관리
    private enum Keys {
        static let profileImage = "profileImage"
        static let profileName = "profileName"
        static let profileId = "profileId"
        
        static let notificationType = "notificationType"
        static let notificationFrequency = "notificationFrequency"
        static let locationEnabled = "locationEnabled"
        static let randomEnabled = "randomEnabled"
        static let eggBreakEnabled = "eggBreakEnabled"
        static let profileVisibility = "profileVisibility"
        static let soundEnabled = "soundEnabled"
    }
    
    // MARK: - Profile Settings

    func saveProfileImage(_ imageData: Data?) {
        defaults.set(imageData, forKey: Keys.profileImage)
    }

    func getProfileImage() -> Data? {
        return defaults.data(forKey: Keys.profileImage)
    }

    func saveProfileName(_ name: String) {
        defaults.set(name, forKey: Keys.profileName)
    }

    func getProfileName() -> String? {
        return defaults.string(forKey: Keys.profileName)
    }

    func saveProfileId(_ id: String) {
        defaults.set(id, forKey: Keys.profileId)
    }

    func getProfileId() -> String? {
        return defaults.string(forKey: Keys.profileId)
    }

    // 프로필 전체 정보 저장
    func saveProfileInfo(name: String, id: String, imageData: Data?) {
        saveProfileName(name)
        saveProfileId(id)
        saveProfileImage(imageData)
    }
    
    // MARK: - Notification Settings
    
    func saveNotificationEnabled(_ enabled: Bool, for type: String) {
        defaults.set(enabled, forKey: "notification_enabled_\(type)")
    }
    
    func getNotificationEnabled(for type: String) -> Bool? {
        if defaults.object(forKey: "notification_enabled_\(type)") != nil {
            return defaults.bool(forKey: "notification_enabled_\(type)")
        }
        return nil
    }
    
    // MARK: - Feature Settings
    
    func saveFeatureSettings(_ settings: FeatureSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: "featureSettings")
        }
    }
    
    func getFeatureSettings() -> FeatureSettings? {
        guard let data = defaults.data(forKey: "featureSettings"),
              let settings = try? JSONDecoder().decode(FeatureSettings.self, from: data) else {
            return nil
        }
        return settings
    }
    
    // MARK: - Profile Visibility
    
    func saveProfileVisibility(_ visibility: ProfileVisibility) {
        defaults.set(visibility.rawValue, forKey: Keys.profileVisibility)
    }
    
    func getProfileVisibility() -> ProfileVisibility {
        let value = defaults.string(
            forKey: Keys.profileVisibility) ?? ProfileVisibility.mutual.rawValue
        return ProfileVisibility(rawValue: value) ?? .mutual
    }
    
    // MARK: - Individual Settings
    
    func saveSoundEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: Keys.soundEnabled)
    }
    
    func isSoundEnabled() -> Bool {
        return defaults.bool(forKey: Keys.soundEnabled)
    }
    
    // 알림 설정 문자열로 변환
    func getAlarmSettingString(for type: String) -> String {
        guard let setting = getNotificationSetting(for: type) else {
            return type == "eggBreak" ? "SOUND_SINGLE" : "SOUND_SINGLE"
        }
        
        // 무음일 경우 MUTE_SINGLE 리턴
        if !setting.isEnabled {
            return "MUTE_SINGLE"
        }
        
        let typeStr: String
        switch setting.type {
        case .mute, .muteSingle, .muteContinuous:
            typeStr = "MUTE"
        case .vibrate, .vibrateSingle, .vibrateContinuous:
            typeStr = "VIBRATE"
        case .sound, .soundSingle, .soundContinuous:
            typeStr = "SOUND"
        case .both, .bothSingle, .bothContinuous:
            typeStr = "BOTH"
        }
        
        // 알 깨기의 경우 주파수가 없으므로 항상 SINGLE
        if type == "eggBreak" {
            return "\(typeStr)_SINGLE"
        }
        
        // 주파수 추가
        let frequencyStr = setting.frequency == .continuous ? "CONTINUOUS" : "SINGLE"
        return "\(typeStr)_\(frequencyStr)"
    }
    
    // 세팅 업데이트 요청 객체 생성
    func createSettingsUpdateRequest() -> SettingsUpdateRequest {
        return SettingsUpdateRequest(
            postAlarm: getNotificationEnabled(for: "friendPost") ?? true,
            commentAlarm: getNotificationEnabled(for: "comment") ?? true,
            placeAlarm: getAlarmSettingString(for: "location"),
            randomAlarm: getAlarmSettingString(for: "random"),
            eggAlarm: getAlarmSettingString(for: "eggBreak"),
            marketingAgree: getUserMarketingAgree() ?? false,
            placeCheck: getFeatureEnabled(for: "location") ?? true,
            randomCheck: getFeatureEnabled(for: "random") ?? true,
            breakAllow: getFeatureEnabled(for: "eggBreak") ?? true,
            accountVisibility: getProfileVisibility().rawValue
        )
    }
    
    func saveNotificationSetting(_ setting: NotificationSetting, for type: String) {
        if let encoded = try? JSONEncoder().encode(setting) {
            defaults.set(encoded, forKey: "\(Keys.notificationType)_\(type)")
        }
    }

    func getNotificationSetting(for type: String) -> NotificationSetting? {
        guard let data = defaults.data(forKey: "\(Keys.notificationType)_\(type)"),
              let setting = try? JSONDecoder().decode(NotificationSetting.self, from: data) else {
            return nil
        }
        return setting
    }
    
    // 기능 활성화 상태 저장/불러오기
    func saveFeatureEnabled(_ enabled: Bool, for type: String) {
        defaults.set(enabled, forKey: "feature_enabled_\(type)")
    }

    func getFeatureEnabled(for type: String) -> Bool? {
        if defaults.object(forKey: "feature_enabled_\(type)") != nil {
            return defaults.bool(forKey: "feature_enabled_\(type)")
        }
        return nil
    }

    // 마케팅 정보 수신 동의 저장/불러오기
    func saveUserMarketingAgree(_ agree: Bool) {
        defaults.set(agree, forKey: "marketing_agree")
    }

    func getUserMarketingAgree() -> Bool? {
        if defaults.object(forKey: "marketing_agree") != nil {
            return defaults.bool(forKey: "marketing_agree")
        }
        return nil
    }
    
    // MARK: - Reset
    
    // func resetAllSettings() {
    //     let domain = Bundle.main.bundleIdentifier?
    //     defaults.removePersistentDomain(forName: domain)
    //     defaults.synchronize()
    // }
}
