//
//  EmailLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

final class EmailLoginManager {
    
    // MARK: - Properties
    
    @MainActor static let shared = EmailLoginManager()
    private let authService = AuthService.shared
   
    private init() {}
    
    // MARK: - Functions
   
    func login(email: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(
            email: email,
            password: password,
            socialType: .email,
            accessToken: nil
        )
        
        return try await authService.login(request: request)
    }
}
