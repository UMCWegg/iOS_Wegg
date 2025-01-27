//
//  LoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation
import UIKit

final class LoginManager {
    static let shared = LoginManager()
    
    private let googleLoginManager = GoogleLoginManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared
    private let emailLoginManager = EmailLoginManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    
    func login(type: SocialType,
               from viewController: UIViewController? = nil,
               email: String? = nil,
               password: String? = nil) {
        switch type {
        case .google:
            guard let viewController else { return }
            googleLoginManager.requestLogin(from: viewController)
            let data = userDefaultsManager.getGoogleData()
            
            print("data Token", data.token ?? "X")
            print("data email", data.email ?? "X")
            
        case .kakao:
            kakaoLoginManager.requestLogin()
            let data = userDefaultsManager.getKakaoData()
            
            print("data Token", data.token ?? "X")
            print("data id", data.id ?? "X")
            
        case .email:
            guard let email = email, let password = password else { return }
            emailLoginManager.login(email: email, password: password)
        }
    }
    
    func handleLoginResponse(_ response: LoginResponse) {
        if let email = response.email {
            UserDefaultsManager.shared.saveGoogleData(
                token: response.accessToken,
                email: email
            )
        } else if let oauthID = response.oauthID {
            UserDefaultsManager.shared.saveKakaoData(
                token: response.accessToken,
                id: oauthID
            )
        }
        
        DispatchQueue.main.async {
            
        }
    }
}
