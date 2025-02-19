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
    @MainActor static let shared = KakaoLoginManager()
    
    func requestSignUp() async throws -> (id: String, token: String) {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await signUpWithApp()
        } else {
            return try await signUpWithWeb()
        }
    }
    
    private func signUpWithApp() async throws -> (id: String, token: String) {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                self?.getSignUpUserInfo(oauthToken: oauthToken) { result in
                    switch result {
                    case .success((let id, let token)):
                        continuation.resume(returning: (id: id, token: token))
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func signUpWithWeb() async throws -> (id: String, token: String) {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                self?.getSignUpUserInfo(oauthToken: oauthToken) { result in
                    switch result {
                    case .success((let id, let token)):
                        continuation.resume(returning: (id: id, token: token))
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func getSignUpUserInfo(
        oauthToken: OAuthToken?,
        completion: @escaping (Result<(String, String), Error>) -> Void) {
            UserApi.shared.me { user, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let id = user?.id else {
                    completion(.failure(LoginError.userNotFound))
                    return
                }
                
                guard let token = oauthToken?.accessToken else {
                    completion(.failure(LoginError.tokenNotFound))
                    return
                }
                
                completion(.success((String(id), token)))
            }
    }
    
    enum LoginError: LocalizedError {
        case userNotFound
        case tokenNotFound
        
        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "사용자를 찾을 수 없습니다"
            case .tokenNotFound:
                return "토큰을 찾을 수 없습니다"
            }
        }
    }
}
