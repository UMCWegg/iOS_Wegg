//
//  APIManager.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import Foundation
import Moya

// MARK: - APIError

/// API 요청 중 발생할 수 있는 에러 타입
enum APIError: Error {
    // 응답 디코딩 실패
    case decodingError
    // 네트워크 관련 에러
    case networkError(String)
    // 알 수 없는 에러
    case unknown
}

// MARK: - APIManager

/// MoyaProvider를 래핑한 API 요청 관리 클래스
/// - Moya의 `MultiTarget`을 사용하여 다양한 TargetType을 하나의 Provider로 관리
class APIManager: APIManagerProtocol {
    private let provider: MoyaProvider<MultiTarget>
    
    /// APIManager 초기화 메서드
    /// - Parameters:
    ///   - provider: MoyaProvider를 주입받음 (기본값은 `MoyaProvider<MultiTarget>()`)
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }
    
    /// API 요청을 처리하는 메서드
    /// - Parameters:
    ///   - target: 요청할 API의 TargetType
    ///   - completion: 요청 결과를 반환하는 클로저 (Result 타입)
    func request<T: Decodable>(
        target: any TargetType,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        // MoyaProvider를 통해 요청 실행
        provider.request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    // JSON 데이터를 Decodable 타입으로 디코딩
                    let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }
}
