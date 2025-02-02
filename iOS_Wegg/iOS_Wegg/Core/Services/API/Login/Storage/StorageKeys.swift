//
//  StorageKeys.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.02.
//

enum StorageKeys {
    enum SignUp {
        static let signUpData = "signUpData"
        static let temporaryUserData = "temporaryUserData"
    }
    
    enum Login {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let userEmail = "userEmail"
    }
}
