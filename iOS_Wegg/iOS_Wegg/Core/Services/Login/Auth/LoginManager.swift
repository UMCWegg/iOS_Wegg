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
    
    func login(type: SocialType,
               from viewController: UIViewController? = nil,
               email: String? = nil,
               password: String? = nil) {
        switch type {
        case .google:
            guard let viewController else { return }
            googleLoginManager.requestLogin(from: viewController)
        case .kakao:
            kakaoLoginManager.requestLogin()
        case .email:
            guard let email = email, let password = password else { return }
            emailLoginManager.login(email: email, password: password)
        }
    }
}
