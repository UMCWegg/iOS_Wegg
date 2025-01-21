//
//  NaverLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import NaverThirdPartyLogin

final class NaverLoginManager {
    static let shared = NaverLoginManager()
    private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private init() {
        setupNaverLogin()
    }
    
    private func setupNaverLogin() {
        loginInstance?.isNaverAppOauthEnable = true
        loginInstance?.isInAppOauthEnable = true
        
        // 네이버 개발자 센터에서 받은 정보
        loginInstance?.serviceUrlScheme = "your_url_scheme"
        loginInstance?.consumerKey = "your_consumer_key"
        loginInstance?.consumerSecret = "your_consumer_secret"
        loginInstance?.appName = "your_app_name"
    }
    
    func requestLogin() {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
}

extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = loginInstance?.accessToken,
              let socialId = loginInstance?.tokenType else { return }
              
        // 여기서 토큰과 ID 저장
        UserDefaultsManager.shared.saveNaverToken(token: accessToken, id: socialId)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {}
    
    func oauth20ConnectionDidFinishDeleteToken() {}
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {}
}
