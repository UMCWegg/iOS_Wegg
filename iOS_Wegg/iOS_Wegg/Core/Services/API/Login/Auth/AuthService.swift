//
//  AuthService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import Alamofire
import Moya

final class AuthService {
    // MARK: - Properties
    
    static let shared = AuthService()
    private let provider = MoyaProvider<APIEndpoint>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func signUp(with request: SignUpRequest) async throws -> SignUpResponse {
        try await request(.signUp(request))
    }
    
    func login(with request: LoginRequest) async throws -> LoginResponse {
        try await request(.login(request))
    }
    
    func socialLogin(type: SocialType, token: String, oauthID: String) async throws -> LoginResponse {
        let processedToken = type == .kakao ? "K\(token)" : token
        return try await request(.socialLogin(type, processedToken, oauthID))
    }
    
    func logout() async throws {
        try await request(.logout)
    }
    
    func verifyEmail(_ email: String) async throws -> VerificationResponse {
        try await request(.verifyEmail(email))
    }
    
    func verifyPhone(_ phone: String) async throws -> VerificationResponse {
        try await request(.verifyPhone(phone))
    }
    
    func checkVerificationNumber(_ number: String) async throws -> VerificationResponse {
        try await request(.verificationNum(number))
    }
    
    func checkAccountId(_ id: String) async throws -> VerificationResponse {
        try await request(.idCheck(id))
    }

    private func request<T: Decodable>(_ target: APIEndpoint) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(T.self)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        continuation.resume(throwing: AuthError.serverError)
                    }
                case .failure:
                    continuation.resume(throwing: AuthError.serverError)
                }
            }
        }
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
