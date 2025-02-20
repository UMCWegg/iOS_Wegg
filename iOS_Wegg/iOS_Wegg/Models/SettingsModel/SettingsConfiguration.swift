//
//  SettingsConfiguration.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

struct NotificationSetting: Codable {
    var type: NotificationType
    var frequency: NotificationFrequency?
    var isEnabled: Bool
    
    var displayText: String {
        if !isEnabled {
            return "꺼짐"
        }
        
        if let frequency = frequency {
            return "\(type.displayName), \(frequency.displayName)"
        }
        return type.displayName
    }
}
