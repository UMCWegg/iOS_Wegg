//
//  EmailLoginManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

final class EmailLoginManager {
   static let shared = EmailLoginManager()
   
   private init() {}
   
   func login(email: String, password: String) {
       let request = LoginRequest(
           type: .email,
           accessToken: nil,
           email: email,
           password: password
       )
       
       AuthService.shared.login(with: request)
   }
}
