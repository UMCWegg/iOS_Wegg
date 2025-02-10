//
//  LoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation
import UIKit

import Combine

final class LoginManager {
    
    // MARK: - Properties
    
    static let shared = LoginManager()
    private var cancellables = Set<AnyCancellable>()
    
    private let googleLoginManager = GoogleLoginManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared
    private let emailLoginManager = EmailLoginManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    private let authService = AuthService.shared
    
    // MARK: - Functions
    
    func login(type: SocialType,
               from viewController: UIViewController? = nil,
               email: String? = nil,
               password: String? = nil) {
        switch type {
        case .google:
            guard let viewController else { return }
            googleLoginManager.requestLogin(from: viewController)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Google login failed: \(error)")
                    }
                } receiveValue: { token in
                    self.handleSocialLogin(type: .google, token: token)
                }
                .store(in: &cancellables)
            
        case .kakao:
            kakaoLoginManager.requestLogin()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Kakao login failed: \(error)")
                    }
                } receiveValue: { token in
                    self.handleSocialLogin(type: .kakao, token: token)
                }
                .store(in: &cancellables)
            
        case .email:
            guard let email = email, let password = password else { return }
            let request = LoginRequest(
                email: email,
                password: password,
                socialType: .email,
                oauthID: nil
            )
            
            authService.login(with: request)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Email login failed: \(error)")
                    }
                } receiveValue: { response in
                    self.handleLoginResponse(response)
                }
                .store(in: &cancellables)
        }
        
    }
    func handleSocialLogin(type: SocialType, token: String) {
        
        let processedToken = switch type {
        case .google:
            token
        case .kakao:
            "K\(token)"
        case .email:
            token
        }
        
        let oauthID: String = switch type {
            case .google:
                userDefaultsManager.getGoogleData().email ?? ""
            case .kakao:
                userDefaultsManager.getKakaoData().id ?? ""
            case .email:
                ""
            }
        
        authService.socialLogin(type: type, token: token, oauthID: oauthID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Social login failed: \(error)")
                }
            } receiveValue: { response in
                self.handleLoginResponse(response)
            }
            .store(in: &cancellables)
    }
    
    private func handleLoginResponse(_ response: LoginResponse) {
        userDefaultsManager.saveToken(response.accessToken)
        
        switch response.type {
        case .google:
            if let email = response.email {
                userDefaultsManager.saveGoogleData(
                    token: response.accessToken,
                    email: email
                )
            }
        case .kakao:
            if let oauthID = response.oauthID {
                // 카카오는 이미 'K'가 붙은 ID가 올 것임
                userDefaultsManager.saveKakaoData(
                    token: response.accessToken,
                    id: oauthID
                )
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
