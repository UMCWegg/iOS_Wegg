//
//  AuthAPI.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.15.
//

import Foundation

import Moya

enum AuthAPI {
    case signUp(request: SignUpRequest)
    case socialSignUp(request: SignUpRequest)
    case login(request: LoginRequest)
    case socialLogin(request: LoginRequest)
    case verifyEmail(email: String)
    case verifyPhone(phone: String)
    case verificationNum(request: CheckVerificationRequest)
    case idCheck(id: String)
    case resign
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .signUp:
            return APIConstants.Auth.signUp
        case .socialSignUp:
            return APIConstants.Auth.socialSignUp
        case .login:
            return APIConstants.Auth.login
        case .socialLogin:
            return APIConstants.Auth.socialLogin
        case .verifyEmail:
            return APIConstants.Auth.verifyEmail
        case .verifyPhone:
            return APIConstants.Auth.verifyPhone
        case .verificationNum:
            return APIConstants.Auth.verificationNum
        case .idCheck:
            return APIConstants.Auth.idCheck
        case .resign:
            return APIConstants.Auth.resign
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login, .socialSignUp,
                .socialLogin, .verifyEmail, .verifyPhone, .verificationNum:
            return .post
        case .idCheck:
            return .get
        case .resign:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .socialSignUp(let request):
            return .requestJSONEncodable(request)
        case .login(let request):
            return .requestJSONEncodable(request)
        case .socialLogin(let request):
            return .requestJSONEncodable(request)
        case .verifyEmail(let email):
            return .requestParameters(
                parameters: ["email": email],
                encoding: JSONEncoding.default)
        case .verifyPhone(let phone):
            return .requestParameters(
                parameters: ["phone": phone],
                encoding: JSONEncoding.default)
        case .verificationNum(let request):
            return .requestJSONEncodable(request)
        case .idCheck(let id):
            return .requestParameters(
                parameters: ["accountId": id],
                encoding: URLEncoding.default)
        case .resign:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .idCheck:
            return nil
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
