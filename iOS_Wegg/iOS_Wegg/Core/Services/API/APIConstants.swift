//
//  APIConstants.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import Foundation

/// API URL 정의한 상수 구조체
struct APIConstants {
    static let baseURL = "https://weggserver.store"
    
    struct Map {
        static let hotplacesURL = "/maps/hotplaces"
        static let schedulePlaceURL = "/maps/plans"
        static let schedulePlaceSearchURL = schedulePlaceURL + "/search"
    }
    
    struct Post {
        static let uploadRandomPost = "/posts"
    }
    
    struct Auth {
        static let signUp = "/users/signup"
        static let login = "/users/login"
        static let socialLogin = "/users/oauth2/login"
        static let logout = "/users/logout"
        static let verifyEmail = "/users/email/send-verification"
        static let verifyPhone = "/users/phone/send-verification"
        static let verificationNum = "/users/verifinum-check"
        static let idCheck = "/users/id-check"
    }
}
