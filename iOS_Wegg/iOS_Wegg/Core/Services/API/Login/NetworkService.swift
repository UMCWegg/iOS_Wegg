//
//  NetworkService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import Foundation

import Moya

enum APIEndpoint {
    case signUp(SignUpRequest)
    case socialSignUp(SocialSignUpRequest)
    case login(LoginRequest)
    case socialLogin(SocialType, String, String)
    case logout
    case updateSettings(String)
    case verifyPhone(String)
    case verifyEmail(String)
    case verificationNum(String)
    case idCheck(String)
    case resign
}

enum NetworkError: Error {
    case serverError
    case invalidData
}

extension APIEndpoint: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://weggserver.store") else {
            fatalError("Error: Invalid URL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/signup"
        case .socialSignUp:
            return "/users/oauth2/signup"
        case .login:
            return "/users/login"
        case .socialLogin:
            return "/users/oauth2/login"
        case .logout:
            return "/users/logout"
        case .verifyPhone:
            return "/users/phone/send-verification"
        case .verifyEmail:
            return "/users/email/send-verification"
        case .updateSettings:
            return "/users/update"
        case .resign:
            return "/users/resign"
        case .verificationNum:
            return "/users/verifinum-check"
        case .idCheck:
            return "/users/id-check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .socialSignUp, .login, .logout, .verifyPhone, .verifyEmail, .verificationNum:
            return .post
        case .socialLogin, .idCheck:
            return .get
        case .updateSettings:
            return .patch
        case .resign:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .socialLogin(let type, let token, let oauthID):
            return .requestParameters(
                parameters: ["type": type.rawValue, "token": token, "oauth_id": oauthID],
                encoding: URLEncoding.queryString)
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .socialSignUp(let request):
            return .requestJSONEncodable(request)
        case .logout:
            return .requestPlain
        case .verifyPhone(let phone):
            return .requestParameters(
                parameters: ["phone": phone],
                encoding: JSONEncoding.default)
        case .verifyEmail(let email):
            return .requestParameters(
                parameters: ["email": email],
                encoding: JSONEncoding.default)
        case .verificationNum(let number):
            return .requestParameters(
                parameters: ["code": number],
                encoding: JSONEncoding.default)
        case .updateSettings(let request):
            return .requestJSONEncodable(request)
        case .idCheck(let id):
            return .requestParameters(
                parameters: ["account": id],
                encoding: URLEncoding.default)
        case .resign:
            return .requestParameters(
                parameters: ["is_active": false],
                encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = UserDefaultsManager.shared.getToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let provider = MoyaProvider<APIEndpoint>()
    
    func request<T: Decodable>(_ endpoint: APIEndpoint,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        provider.request(endpoint) { result in
            switch result {
            case .success(let response):
                print("Request Endpoint: \(endpoint)")
                
                // 상태 코드 확인 추가
                guard (200...299).contains(response.statusCode) else {
                    print("Error status code: \(response.statusCode)")
                    completion(.failure(.serverError))
                    return
                }
                
                if let responseJson = String(data: response.data, encoding: .utf8) {
                    print("Full Response JSON:", responseJson)
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    print("Detailed Decoding error:", error)
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                print("Network error:", error)
                completion(.failure(.serverError))
            }
        }
    }
}

extension APIEndpoint: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(describing: self))
    }
}
