//
//  KakaoLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import Combine
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLoginManager {
    static let shared = KakaoLoginManager()

    // 회원가입
    func requestSignUp() -> AnyPublisher<String, Error> {
        Future { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                self.signUpWithApp { result in
                    promise(result)
                }
            } else {
                self.signUpWithWeb { result in
                    promise(result)
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // 로그인
    func requestLogin() -> AnyPublisher<String, Error> {
        Future { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginWithApp { result in
                    promise(result)
                }
            } else {
                self.loginWithWeb { result in
                    promise(result)
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func signUpWithApp(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.getSignUpUserInfo(oauthToken: oauthToken, completion: completion)
        }
    }
    
    private func signUpWithWeb(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.getSignUpUserInfo(oauthToken: oauthToken, completion: completion)
        }
    }
    
    private func loginWithApp(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.getUserInfo(oauthToken: oauthToken) { result in
                completion(result)
            }
        }
    }
    
    private func loginWithWeb(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.getUserInfo(oauthToken: oauthToken) { result in
                completion(result)
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
                
                guard let id = user?.id else {
                    completion(.failure(LoginError.userNotFound))
                    return
                }
                
                completion(.success(String(id)))
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
                    token: oauthToken?.accessToken ?? "",
                    id: String(id)
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
