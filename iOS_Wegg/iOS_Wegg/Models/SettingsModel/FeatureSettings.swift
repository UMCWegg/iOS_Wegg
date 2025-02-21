//
//  FeatureSettings.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import Foundation

struct FeatureSettings: Codable {
    var isLocationEnabled: Bool
    var isRandomEnabled: Bool
    var isEggBreakEnabled: Bool
    
    var disabledMessage: String? {
        if !isLocationEnabled {
            return "장소 인증 기능을 끄면 다른 친구들의 게시물을 볼 수 없어요"
        }
        if !isRandomEnabled {
            return "랜덤 인증 기능을 끄면 다른 친구들의 게시물을 볼 수 없어요"
        }
        return nil
    }
}
