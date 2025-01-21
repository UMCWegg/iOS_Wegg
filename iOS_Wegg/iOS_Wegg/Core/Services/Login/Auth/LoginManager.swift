//
//  LoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

final class LoginManager {
    static let shared = LoginManager()
    
    private let naverLoginManager = NaverrLoginManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared
    private let emailLoginManager = EmailLoginManager.shared
    
    
    func login(type: SocialType, email: String? = nil, password: String? = nil) {
        switch type {
        case .naver:
            naverLoginManager.requestLogin()
        case .kakao:
            kakaoLoginManager.requestLogin()
        case .email:
            guard let email = email, let password = password else { return }
            emailLoginManager.login(email: email, password: password)
        }
    }
}
