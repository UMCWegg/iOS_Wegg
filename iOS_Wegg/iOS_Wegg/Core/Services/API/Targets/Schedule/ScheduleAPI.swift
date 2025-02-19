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
    case addSchedule(request: AddScheduleRequest)
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
            return APIConstants.Schedule.schedulePlaceSearchURL
        case .addSchedule:
            return APIConstants.Schedule.addURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlace:
            return .get
        case .addSchedule:
            return .post
        }
    }
    
    var task: Task {
        switch self {
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
        case .addSchedule(let request):
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
