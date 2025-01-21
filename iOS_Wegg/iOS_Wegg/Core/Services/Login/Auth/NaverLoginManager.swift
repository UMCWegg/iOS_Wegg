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
            guard let accessToken = loginInstance?.accessToken else { return }
            
            let request = LoginRequest(
                type: .naver,
                accessToken: accessToken,
                email: nil,
                password: nil
            )
            
            AuthService.shared.login(with: request) { result in
                switch result {
                case .success(let response):
                    print("Login success: \(response)")
                case .failure(let error):
                    print("Login failed: \(error)")
                }
            }
        }
   
   func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {}
   func oauth20ConnectionDidFinishDeleteToken() {}
   func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!,
                          didFailWithError error: Error!) {}
}
