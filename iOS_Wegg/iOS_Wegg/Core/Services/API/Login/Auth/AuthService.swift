//
//  AuthService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import Alamofire
import Combine
import CombineMoya
import Moya

final class AuthService {
    // MARK: - Properties
    
    static let shared = AuthService()
    private let provider = MoyaProvider<APIEndpoint>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func signUp(with request: SignUpRequest) -> AnyPublisher<SignUpResponse, Error> {
        publisher(.signUp(request))
    }
    
    func socialSignUp(request: SocialSignUpRequest) -> AnyPublisher<SignUpResponse, Error> {
        publisher(.socialSignUp(request))
    }
    func login(with request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        publisher(.login(request))
    }
    
    func socialLogin(
        type: SocialType,
        token: String,
        oauthID: String) -> AnyPublisher<LoginResponse, Error> {
        let processedToken = type == .kakao ? "K\(token)" : token
        return publisher(.socialLogin(type, processedToken, oauthID))
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.logout)
            .filterSuccessfulStatusCodes()
            .map { _ in }
            .mapError { error in
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode:
                        return AuthError.serverError
                    default:
                        return error
                    }
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func verifyEmail(_ email: String) -> AnyPublisher<VerificationResponse, Error> {
        publisher(.verifyEmail(email))
    }
    
    func verifyPhone(_ phone: String) -> AnyPublisher<VerificationResponse, Error> {
        publisher(.verifyPhone(phone))
    }
    
    func checkVerificationNumber(_ number: String) -> AnyPublisher<VerificationResponse, Error> {
        publisher(.verificationNum(number))
    }
    
    func checkAccountId(_ id: String) -> AnyPublisher<VerificationResponse, Error> {
        publisher(.idCheck(id))
    }

    private func publisher<T: Decodable>(_ target: APIEndpoint) -> AnyPublisher<T, Error> {
        return provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .tryMap { response -> T in
                try response.map(T.self, using: JSONDecoder())
            }
            .mapError { error in
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode:
                        return AuthError.serverError
                    default:
                        return error
                    }
                }
                return error
            }
            .eraseToAnyPublisher()
    }

}

// MARK: - Error Handling

extension AuthService {
    enum AuthError: LocalizedError {
        case invalidToken
        case userNotFound
        case serverError
        
        var errorDescription: String? {
            switch self {
            case .invalidToken:
                return "유효하지 않은 토큰입니다"
            case .userNotFound:
                return "사용자를 찾을 수 없습니다"
            case .serverError:
                return "서버 오류가 발생했습니다"
            }
        }
    }
}
