//
//  StorageKeys.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

import Foundation

enum StorageKeys {
    enum SignUp {
        static let signUpData = "signUpData"
        static let temporaryUserData = "temporaryUserData"
    }
    
    enum Login {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let userEmail = "userEmail"
        
        static let userID = "userID"
    }
    
    enum Social {
        static let googleToken = "googleToken"
        static let googleEmail = "googleEmail"
        static let kakaoToken = "kakaoToken"
        static let kakaoID = "kakaoID"
    }
}
