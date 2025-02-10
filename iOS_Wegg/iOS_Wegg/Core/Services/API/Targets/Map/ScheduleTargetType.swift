//
//  ScheduleTargetType.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation
import Moya

struct SearchRequest: Encodable {
    let keyword: String
    let latitude: String
    let longitude: String
}

struct SearchResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PlaceListResult
    
    struct PlaceListResult: Decodable {
        let placeList: [Place]
        
        struct Place: Decodable {
            let placeName: String
        }
    }
}

/// 장소 검색 API 정의
enum ScheduleTargetType {
    case searchPlace(request: SearchRequest)
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
        request: SearchRequest,
        completion: @escaping (Result<SearchResponse, APIError>) -> Void
    ) {
        self.request(
            target: ScheduleTargetType.searchPlace(request: request),
            completion: completion
        )
    }
}
