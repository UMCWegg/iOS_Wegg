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
    
    // MARK: - Reset
    
    // func resetAllSettings() {
    //     let domain = Bundle.main.bundleIdentifier?
    //     defaults.removePersistentDomain(forName: domain)
    //     defaults.synchronize()
    // }
}
