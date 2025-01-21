//
//  KakaoLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLoginManager {
   static let shared = KakaoLoginManager()
   
   private init() {}
   
   func requestLogin() {
       if UserApi.isKakaoTalkLoginAvailable() {
           loginWithApp()
       } else {
           loginWithWeb()
       }
   }
   
    private func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in  // [weak self] 제거
            if let error = error {
                print(error)
                return
            }
            
            guard let token = oauthToken?.accessToken else { return }
            
            let request = LoginRequest(
                type: .kakao,
                accessToken: token,
                email: nil,
                password: nil
            )
            
            AuthService.shared.login(with: request) { result in
                switch result {
                case .success(let response):
                    // TODO: 토큰 저장 및 성공 처리
                    print("Login success: \(response)")
                case .failure(let error):
                    // TODO: 에러 처리
                    print("Login failed: \(error)")
                }
            }
        }
    }
   
   private func loginWithWeb() {
       UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
           // App 로그인과 동일한 처리
       }
   }
}
