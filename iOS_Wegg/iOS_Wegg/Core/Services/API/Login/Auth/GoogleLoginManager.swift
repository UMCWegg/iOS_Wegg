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
    
    // 회원가입
    func requestSignUp(from viewController: UIViewController) -> AnyPublisher<String, Error> {
        return Future { promise in
            self.googleService.signIn(presenting: viewController) { result in
                switch result {
                case .success((let email, _)):
                    promise(.success(email))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // 로그인
    func requestLogin(from viewController: UIViewController) -> AnyPublisher<String, Error> {
        return Future { promise in
            self.googleService.signIn(presenting: viewController) { result in
                switch result {
                case .success((let email, let token)):
                    UserDefaultsManager.shared.saveGoogleData(token: token, email: email)
                    promise(.success(email))  // 서버 통신 제거, 정보만 전달
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
