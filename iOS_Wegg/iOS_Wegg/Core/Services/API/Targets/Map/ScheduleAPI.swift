//
//  ScheduleTargetType.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation
import Moya

/// 일정 관련 API 정의
enum ScheduleAPI {
    case searchPlace(request: ScheduleSearchRequest)
}

extension ScheduleAPI: TargetType {
    
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
            return .get
        }
    }
    
    var task: Task {
        switch self {
            //        case .searchPlace(let request):
            //            return .requestJSONEncodable(request)
            //        }
        case .searchPlace(let request):
            return .requestParameters(
                parameters: [
                    "keyword": request.keyword,
                    "latitude": request.latitude,
                    "longitude": request.longitude,
                    "page": request.page,
                    "size": request.size
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
//        return [
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
