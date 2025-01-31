//
//  GoogleService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import GoogleSignIn

final class GoogleService {
    static let shared = GoogleService()
    private let clientID =
    "498161093152-ajp8av7ktm4gcakp3fqjkbutbehjuebl.apps.googleusercontent.com"
    
    private init() {
        setupGoogleSignIn()
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }
    
    func signIn(presenting viewController: UIViewController,
                completion: @escaping (Result<(String, String), Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let email = signInResult?.user.profile?.email,
                  let token = signInResult?.user.accessToken.tokenString else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            completion(.success((email, token)))
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
