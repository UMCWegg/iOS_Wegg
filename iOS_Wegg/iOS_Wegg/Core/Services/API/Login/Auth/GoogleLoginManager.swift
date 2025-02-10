//
//  GoogleLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import UIKit

import Combine
import GoogleSignIn
import FirebaseAuth

final class GoogleLoginManager {
    static let shared = GoogleLoginManager()
    private let googleService = GoogleService.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    func requestLogin(from viewController: UIViewController) -> AnyPublisher<String, Error> {
        return Future { promise in
            self.googleService.signIn(presenting: viewController) { result in
                switch result {
                case .success((let email, let token)):
                    UserDefaultsManager.shared.saveGoogleData(token: token, email: email)
                    promise(.success(email))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
