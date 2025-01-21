//
//  GoogleLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import UIKit

final class GoogleLoginManager {
    static let shared = GoogleLoginManager()
    private let googleService = GoogleService.shared
    
    private init() {}
    
    func requestLogin(from viewController: UIViewController) {
        googleService.signIn(presenting: viewController) { result in
            switch result {
            case .success((let email, let token)):
                let request = LoginRequest(
                    type: .google,
                    accessToken: token,
                    email: email,
                    password: nil
                )
                
                AuthService.shared.login(with: request) { result in
                    switch result {
                    case .success(let response):
                        print("Login success: \(response)")
                    case .failure(let error):
                        print("Login failed: \(error)")
                    }
                }
            case .failure(let error):
                print("Google sign in failed: \(error)")
            }
        }
    }
}
