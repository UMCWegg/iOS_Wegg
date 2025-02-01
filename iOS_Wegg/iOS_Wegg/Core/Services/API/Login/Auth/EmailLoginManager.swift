//
//  EmailLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import Combine
import Dispatch

final class EmailLoginManager {
    static let shared = EmailLoginManager()
   
    private init() {}
    
    private var cancellables: Set<AnyCancellable> = []
   
    func login(email: String, password: String) {
        let request = LoginRequest(
            type: .email,
            accessToken: nil,
            email: email,
            password: password
        )
        
        AuthService.shared.login(with: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("로그인 실패: \(error)")
                }
            } receiveValue: { response in
                print("로그인 성공: \(response)")
            }
            .store(in: &cancellables)
    }
}
