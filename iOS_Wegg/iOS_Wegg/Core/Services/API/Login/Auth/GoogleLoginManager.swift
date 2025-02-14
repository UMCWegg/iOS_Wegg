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
    static let shared = GoogleLoginManager()
    private let googleService = GoogleService.shared
    
    func requestSignUp(from viewController: UIViewController) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.googleService.signIn(presenting: viewController) { result in
                switch result {
                case .success((let email, _)):
                    continuation.resume(returning: email)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
