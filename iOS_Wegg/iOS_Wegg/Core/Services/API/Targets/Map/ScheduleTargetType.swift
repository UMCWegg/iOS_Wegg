//
//  ScheduleTargetType.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation
import Moya

/// 장소 검색 API 정의
enum ScheduleTargetType {
    case searchPlace(request: ScheduleSearchRequest)
}

extension ScheduleTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ [ScheduleTargetType] 유효하지 않은 URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .searchPlace:
            return APIConstants.Map.schedulePlaceSearchURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlace:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .searchPlace(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

// 장소 검색 API 호출 함수
extension APIManager {
    func searchPlace(
        request: ScheduleSearchRequest,
        completion: @escaping (Result<ScheduleSearchResponse, APIError>) -> Void
    ) {
        self.request(
            target: ScheduleTargetType.searchPlace(request: request),
            completion: completion
        )
    }
}
