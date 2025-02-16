//
//  GoogleService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import GoogleSignIn

final class GoogleService {
    @MainActor static let shared = GoogleService()
    private let clientID = APIKeys.googleClientId
    private init() {
        setupGoogleSignIn()
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }
    
    func signIn(
        presenting viewController: UIViewController,
        completion: @escaping (Result<(email: String, token: String), Error>) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let email = signInResult?.user.profile?.email,
                  let token = signInResult?.user.accessToken.tokenString else {
                let error = NSError(
                    domain: "GoogleSignIn",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get email or token"]
                )
                completion(.failure(error))
                return
            }
            
            completion(.success((email: email, token: token)))
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
