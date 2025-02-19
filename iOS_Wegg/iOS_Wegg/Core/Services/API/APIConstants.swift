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
        static let baseURL = "/maps"
        static let hotplacesURL = Map.baseURL + "/hotplaces"
        static let detailInfoURL = Map.baseURL + "/details"
    }
    
    struct Schedule {
        static let baseURL = "/plans"
        static let schedulePlaceURL = Map.baseURL + Schedule.baseURL
        static let schedulePlaceSearchURL = schedulePlaceURL + "/search"
        static let addURL = Schedule.baseURL + "/add"
        static let onOffURL = "/onoff"
    }
    
    struct Post {
        static let uploadRandomPost = "/posts"
    }
    
    struct Auth {
        static let signUp = "/users/signup"
        static let socialSignUp = "/users/oauth2/signup"
        static let login = "/users/login"
        static let socialLogin = "/users/oauth2/login"
        static let verifyEmail = "/users/email/send-verification"
        static let verifyPhone = "/users/phone/send-verification"
        static let verificationNum = "/users/verifinum-check"
        static let idCheck = "/users/id-check"
        static let emailCheck = "/users/email-check"
        static let resign = "/users/resign"
        static let search = "/users/search"
    }

    struct Todo {
        static let addTodoListURL = "/todo/add" /// 투두 등록
        /// 투두 수정
        static func editTodoURL(todoId: Int) -> String {
            return "/todo/\(todoId)"
        }
        /// 투두 달성체크
        static func checkTodoURL(todoId: Int) -> String {
            return "/todo/\(todoId)/check"
        }
        /// 달성률 조회
        static let achivementTodoURL = "/todo/achivement"
        static let todoURL = "/todo" /// 투두리스트 조회
        /// 투두 삭제
        static func deleteTodoURL(todoId: Int) -> String {
            return "/todo/\(todoId)"
        }
    }
}
