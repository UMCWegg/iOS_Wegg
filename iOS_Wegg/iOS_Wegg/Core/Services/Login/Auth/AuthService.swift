//
//  AuthService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.21.
//

import Foundation

import Alamofire

final class AuthService {
    // MARK: - Properties
    
    static let shared = AuthService()
    private let baseURL = "YOUR_BASE_URL"
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func login(with request: LoginRequest, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/auth/login"
        
        AF.request(
            endpoint,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Error Handling

extension AuthService {
    enum AuthError: LocalizedError {
        case invalidToken
        case userNotFound
        case serverError
        
        var errorDescription: String? {
            switch self {
            case .invalidToken:
                return "유효하지 않은 토큰입니다"
            case .userNotFound:
                return "사용자를 찾을 수 없습니다"
            case .serverError:
                return "서버 오류가 발생했습니다"
            }
        }
    }
}
