//
//  APIManager.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/1/25.
//

import Foundation
import Moya
import Alamofire

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

// MARK: - 쿠키 저장

/// 쿠키 자동 전송을 위한 MoyaProvider 커스텀 Session 생성
private let customSession: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.httpCookieStorage = HTTPCookieStorage.shared // 쿠키 자동 저장 및 전송
    configuration.httpCookieAcceptPolicy = .always
    configuration.httpShouldSetCookies = true
    return Session(configuration: configuration)
}()

/// 테스트 환경에서 SSL 인증서 검증 무시.
private let insecureSession: Session = {
    let configuration = URLSessionConfiguration.default
    let manager = ServerTrustManager(
        evaluators: [
            "3.38.86.106": DisabledTrustEvaluator(),
            "weggserver.store": DisabledTrustEvaluator()
        ]
    )
    return Session(configuration: configuration, serverTrustManager: manager)
}()

// MARK: - APIManager

/// MoyaProvider를 래핑한 API 요청 관리 클래스
/// - Moya의 `MultiTarget`을 사용하여 다양한 TargetType을 하나의 Provider로 관리
class APIManager: APIManagerProtocol {
    private let provider: MoyaProvider<MultiTarget>
    
    /// APIManager 초기화 메서드
    /// - Parameters:
    ///   - provider: MoyaProvider를 주입받음 (기본값은 `MoyaProvider<MultiTarget>()`)
    /// - MoyaProvider에 customSession 적용
    init(provider: MoyaProvider<MultiTarget> = {
#if DEBUG
        return MoyaProvider<MultiTarget>(session: insecureSession) // 테스트 환경
#else
        return MoyaProvider<MultiTarget>(session: customSession)   // 프로덕션 환경
#endif
    }()) {
        self.provider = provider
    }
    
    /// API 요청을 처리하는 메서드
    /// - Parameters:
    ///   - target: 요청할 API의 TargetType
    ///   - completion: 요청 결과를 반환하는 클로저 (Result 타입)
    func request<T: Decodable>(target: any TargetType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    print("🔍 [APIManager] 응답 코드: \(response.statusCode)")
                    
                    do {
                        // JSON 데이터를 Decodable 타입으로 디코딩
                        let decodedResponse = try JSONDecoder().decode(
                            T.self, from: response.data
                        )
                        
                        // 서버 응답에서 쿠키 자동 저장
                        self.saveCookies(from: response.response)
                        
                        // 요청 헤더에 쿠키가 포함되었는지 로그 확인
                        if let requestCookies = HTTPCookieStorage.shared.cookies {
                            print("🍪 [APIManager] 요청에 포함된 쿠키: \(requestCookies)")
                        }
                        
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        print("❌ [APIManager] 디코딩 실패: \(error)")
                        continuation.resume(throwing: APIError.decodingError)
                    }
                    
                case .failure(let error):
                    if let response = error.response {
                        print("❌ [APIManager] 요청 실패 - 응답 코드: \(response.statusCode)")
                    } else {
                        print("❌ [APIManager] 네트워크 연결 오류: \(error.localizedDescription)")
                    }
                    continuation.resume(
                        throwing: APIError.networkError(error.localizedDescription)
                    )
                }
            }
        }
    }
    
    /// 서버에서 받은 쿠키를 저장하는 함수
    private func saveCookies(from response: HTTPURLResponse?) {
        guard let response = response,
              let headerFields = response.allHeaderFields as? [String: String],
              let url = response.url else { return }
        
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
        
        // 저장된 쿠키를 확인하는 로그 추가
        if cookies.isEmpty {
            print("⚠️ [APIManager] 저장할 쿠키가 없습니다.")
        } else {
            cookies.forEach { cookie in
                HTTPCookieStorage.shared.setCookie(cookie)
                print("✅ [APIManager] 쿠키 저장됨: \(cookie.name) = \(cookie.value)")
            }
        }
    }
    
    /// 원하는 쿠키를 직접 저장 (수동 저장)
    func setCookie(
        value: String,
        path: String = "/"
    ) {
        let properties: [HTTPCookiePropertyKey: Any] = [
            .name: "JSESSIONID",
            .value: value,
            .domain: "weggserver.store",
            .path: path,
            .secure: "TRUE",
            .expires: Date(timeIntervalSinceNow: 60 * 60 * 24 * 7) // 7일 후 만료
        ]
        
        if let cookie = HTTPCookie(properties: properties) {
            HTTPCookieStorage.shared.setCookie(cookie)
            print("✅ [APIManager] 수동 쿠키 저장됨: JSESSIONID = \(value)")
            print("🍪 [APIManager] 저장된 쿠키: \(cookie)")
        } else {
            print("❌ [APIManager] 수동 쿠키 저장 실패")
        }
    }
    
    /// 현재 저장된 모든 쿠키 확인 (디버깅용)
    func getAllCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            print("🍪 [APIManager] 현재 저장된 쿠키 목록:")
            cookies.forEach { print("   - \($0.name) = \($0.value)") }
        } else {
            print("⚠️ [APIManager] 저장된 쿠키가 없습니다.")
        }
    }
}
