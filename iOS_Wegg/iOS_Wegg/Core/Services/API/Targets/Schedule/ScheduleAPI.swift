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
    case fetchScheduleList
    case deleteSchedule(planId: Int)
    case searchPlace(request: ScheduleSearchRequest)
    case addSchedule(request: AddScheduleRequest)
    case onOffSchedule(planId: Int, request: OnOffScheduleRequest)
    case editScheduleStatus(planId: Int, request: EditScheduleStatusRequest)
    case editSchedule(planId: Int, request: EditScheduleRequest)
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
        case .fetchScheduleList:
            return APIConstants.Schedule.baseURL
        case .deleteSchedule(let planId):
            return APIConstants.Schedule.baseURL + "/\(planId)"
        case .searchPlace:
            return APIConstants.Schedule.schedulePlaceSearchURL
        case .addSchedule:
            return APIConstants.Schedule.addURL
        case .onOffSchedule(let planId, _):
            return (APIConstants.Schedule.baseURL
            + "/\(planId)" + APIConstants.Schedule.onOffURL)
        case .editScheduleStatus(let planId, _):
            return "/plans/\(planId)/status"
        case .editSchedule(let planId, _):
            return "/plans/\(planId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchScheduleList, .searchPlace:
            return .get
        case .deleteSchedule:
            return .delete
        case .addSchedule:
            return .post
        case .onOffSchedule:
            return .patch
        case .editScheduleStatus, .editSchedule:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchScheduleList:
            return .requestPlain
        case .deleteSchedule:
            return .requestPlain
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
        case .onOffSchedule(_, let request):
            return .requestJSONEncodable(request)
        case .editScheduleStatus(_, let request):
            return .requestJSONEncodable(request)
        case .editSchedule(_, let request):
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
