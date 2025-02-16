//
//  AuthService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

import Alamofire

final class AuthService {
    static let shared = AuthService()
    private let apiManager = APIManager()
    
    private init() {}
    
    func signUp(request: SignUpRequest) async throws -> SignUpResponse {
        try await apiManager.request(target: AuthAPI.signUp(request: request))
    }
    
    func socialSignUp(request: SignUpRequest) async throws -> SignUpResponse {
        try await apiManager.request(target: AuthAPI.socialSignUp(request: request))
    }
    
    func login(request: LoginRequest) async throws -> LoginResponse {
        try await apiManager.request(target: AuthAPI.login(request: request))
    }
    
    func socialLogin(request: LoginRequest) async throws -> LoginResponse {
        try await apiManager.request(target: AuthAPI.socialLogin(request: request))
    }
    
    func verifyEmail(_ email: String) async throws -> BaseResponse<SendVerification> {
        try await apiManager.request(target: AuthAPI.verifyEmail(email: email))
    }
    
    func verifyPhone(_ phone: String) async throws -> BaseResponse<SendVerification> {
        try await apiManager.request(target: AuthAPI.verifyPhone(phone: phone))
    }
    
    func checkVerificationNumber(_ code: String) async throws -> BaseResponse<CheckVerification> {
        try await apiManager.request(target: AuthAPI.verificationNum(code: code))
    }
    
    func checkAccountId(_ id: String) async throws -> BaseResponse<IDCheckResult> {
        try await apiManager.request(target: AuthAPI.idCheck(id: id))
    }
    
    func resign() async throws -> EmptyResponse {
        try await apiManager.request(target: AuthAPI.resign)
    }
}

struct EmptyResponse: Codable {}
