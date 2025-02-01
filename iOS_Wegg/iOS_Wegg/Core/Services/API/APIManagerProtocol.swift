//
//  APIManagerProtocol.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import Foundation
import Moya

/// API 요청을 추상화한 프로토콜
/// - 공통된 `request` 메서드를 통해 모든 API 요청을 처리할 수 있음
protocol APIManagerProtocol {
    /// 제네릭을 사용하여 다양한 Decodable 응답 처리
    /// - Parameters:
    ///   - target: 요청할 API의 TargetType
    ///   - completion: 요청 결과를 반환하는 클로저 (Result 타입으로 성공/실패 구분)
    func request<T: Decodable>(
        target: TargetType,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
