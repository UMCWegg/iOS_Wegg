//
//  LoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation
import UIKit

@MainActor
final class LoginManager {
    
    // MARK: - Properties
    
    @MainActor static let shared = LoginManager()
    
    @MainActor private let googleLoginManager = GoogleLoginManager.shared
    @MainActor private let kakaoLoginManager = KakaoLoginManager.shared
    @MainActor private let emailLoginManager = EmailLoginManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    private let authService = AuthService.shared
    private let sseClient = SSEClient()
    
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
        
        let (email, token) = try await googleLoginManager.requestSignUp(from: viewController)
        let request = LoginRequest(
            email: email,
            password: nil,
            socialType: .google,
            accessToken: token
        )
        
        return try await authService.socialLogin(request: request)
    }
    
    private func handleKakaoLogin() async throws -> LoginResponse {
        let (id, token) = try await kakaoLoginManager.requestSignUp()
        let request = LoginRequest(
            email: "K\(id)@daum.net",
            password: nil,
            socialType: .kakao,
            accessToken: token
        )
        
        return try await authService.socialLogin(request: request)
    }
    
    private func handleEmailLogin(email: String?, password: String?) async throws -> LoginResponse {
        guard let email = email, let password = password else {
            throw NSError(domain: "LoginError",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Email and password are required"])
        }
        
        let request = LoginRequest(
            email: email,
            password: password,
            socialType: nil,
            accessToken: nil
        )
        
        return try await authService.login(request: request)
    }
    
    private func handleLoginResponse(_ response: LoginResponse) {
        if response.isSuccess, let userID = response.result?.userID {
            // 로그인 성공시 UserID 저장
            UserDefaultsManager.shared.saveUserID(userID)
            
            startSSESubscription(userId: String(userID))
            
            // 메인 화면으로 이동
            NotificationCenter.default.post(
                name: NSNotification.Name("LoginSuccess"),
                object: nil
            )
        } else {
            // 로그인 실패시 회원가입 확인 알림32
            NotificationCenter.default.post(
                name: NSNotification.Name("ShowSignUpAlert"),
                object: nil
            )
        }
    }
    
    private func startSSESubscription(userId: String) {
        sseClient.subscribe(userId: userId)
    }
    
    func stopSSESubscription() {
        sseClient.disconnect()
    }
}
