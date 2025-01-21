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
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let token = oauthToken?.accessToken else { return }
            
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let id = user?.id else { return }
                
                let request = LoginRequest(
                    type: .kakao,
                    accessToken: String(id),
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
        }
    }
    
    private func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let token = oauthToken?.accessToken else { return }
            
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let id = user?.id else { return }
                
                let request = LoginRequest(
                    type: .kakao,
                    accessToken: String(id),
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
        }
    }
}
