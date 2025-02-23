//
//  SignUpManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

final class SignUpManager {
    static let shared = SignUpManager()
    private let authService = AuthService.shared
    
    private init() {}
    
    func signUp(data: UserSignUpStorage.SignUpData) async throws -> SignUpResponse {
        return try await authService.signUp(request: data.toSignUpRequest())
    }2
}
