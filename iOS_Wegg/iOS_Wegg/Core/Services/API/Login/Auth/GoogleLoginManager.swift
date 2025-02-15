//
//  GoogleLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import UIKit

import GoogleSignIn
import FirebaseAuth

final class GoogleLoginManager {
    @MainActor static let shared = GoogleLoginManager()
    private let googleService = GoogleService.shared
    
    func requestSignUp(from viewController: UIViewController) async throws
    -> (email: String, token: String) {
        try await withCheckedThrowingContinuation { continuation in
            self.googleService.signIn(presenting: viewController) { result in
                switch result {
                case .success((let email, let token)):
                    continuation.resume(returning: (email: email, token: token))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
