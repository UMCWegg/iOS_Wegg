//
//  KakaoLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLoginManager {
    static let shared = KakaoLoginManager()
    
    func requestSignUp() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await signUpWithApp()
        } else {
            return try await signUpWithWeb()
        }
    }
    
    private func signUpWithApp() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                self?.getSignUpUserInfo(oauthToken: oauthToken) { result in
                    switch result {
                    case .success(let email):
                        continuation.resume(returning: email)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func signUpWithWeb() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                self?.getSignUpUserInfo(oauthToken: oauthToken) { result in
                    switch result {
                    case .success(let email):
                        continuation.resume(returning: email)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func getSignUpUserInfo(
        oauthToken: OAuthToken?,
        completion: @escaping (Result<String, Error>) -> Void) {
            UserApi.shared.me { user, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let email = user?.kakaoAccount?.email else {
                    completion(.failure(LoginError.userNotFound))
                    return
                }
                
                completion(.success(email))
        }
    }

    private func getUserInfo(
        oauthToken: OAuthToken?,
        completion: @escaping (Result<String, Error>) -> Void) {
            UserApi.shared.me { user, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let id = user?.id else {
                    completion(.failure(LoginError.userNotFound))
                    return
                }
                
                UserDefaultsManager.shared.saveKakaoData(
                    email: String(id)
                )
                completion(.success(String(id)))
            }
        }
    
    enum LoginError: LocalizedError {
        case userNotFound
        
        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "사용자를 찾을 수 없습니다"
            }
        }
    }
}
