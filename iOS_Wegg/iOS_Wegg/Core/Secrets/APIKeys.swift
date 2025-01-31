//
//  APIKeys.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.28.
//

import Foundation

enum APIKeys {
    static let kakaoAppKey: String = Bundle.main.object(
        forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? ""
    static let googleClientId: String = Bundle.main.object(
        forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String ?? ""
}
