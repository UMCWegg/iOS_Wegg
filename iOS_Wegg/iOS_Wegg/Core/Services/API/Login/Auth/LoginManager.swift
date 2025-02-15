//
//  LoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation
import UIKit

final class LoginManager {
    
    // MARK: - Properties
    
    static let shared = LoginManager()
    
    private let googleLoginManager = GoogleLoginManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared
    private let emailLoginManager = EmailLoginManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    private let authService = AuthService.shared
    
    // MARK: - Functions
    
    func login(type: SocialType,
               from viewController: UIViewController? = nil,
               email: String? = nil,
               password: String? = nil) async {
        do {
            let response: LoginResponse
            
            switch type {
            case .google:
                response = try await handleGoogleLogin(from: viewController)
            case .kakao:
                response = try await handleKakaoLogin()
            case .email:
                response = try await handleEmailLogin(email: email, password: password)
            }
            
            handleLoginResponse(response)
            
        } catch {
            print("\(type) login failed: \(error)")
        }
    }
        
    private func handleGoogleLogin(
        from viewController: UIViewController?) async throws -> LoginResponse {
        guard let viewController else {
            throw NSError(domain: "LoginError",
                          code: -1,
                          userInfo:
                            [NSLocalizedDescriptionKey: "ViewController is required"]
            )
        }
        
        let email = try await googleLoginManager.requestSignUp(from: viewController)
        let request = LoginRequest(
            email: email,
            password: nil
        )
        
        return try await authService.login(request: request)
    }
    
    private func handleKakaoLogin() async throws -> LoginResponse {
        let oauthID = try await kakaoLoginManager.requestSignUp()
        let request = LoginRequest(
            email: "K\(oauthID)@daum.net",
            password: nil
        )
        
        return try await authService.login(request: request)
    }
    
    private func handleEmailLogin(email: String?, password: String?) async throws -> LoginResponse {
        guard let email = email, let password = password else {
            throw NSError(domain: "LoginError",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Email and password are required"])
        }
        
        return try await emailLoginManager.login(email: email, password: password)
    }
    
    private func handleLoginResponse(_ response: LoginResponse) {
        switch response.type {
        case .google:
            if let email = response.email {
                userDefaultsManager.saveGoogleData(email: email)
            }
        case .kakao:
            if let email = response.email {
                userDefaultsManager.saveKakaoData(email: email)
            }
        case .email:
            break
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("LoginSuccess"),
            object: nil
        )
    }
}
