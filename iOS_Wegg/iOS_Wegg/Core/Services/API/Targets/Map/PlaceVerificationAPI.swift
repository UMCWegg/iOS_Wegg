//
//  PlaceVerificationAPI.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/20/25.
//

import Foundation
import Moya

enum PlaceVerificationAPI {
    /// 장소 인증 화면에 필요한 API
    case getkPlaceVerification(planId: Int)
    /// 실제 장소 인증을 수행하는 API
//    case checkPlaceVerification(planId: Int)
}

extension PlaceVerificationAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ [ScheduleTargetType] 유효하지 않은 URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getkPlaceVerification(let planId):
            return "/plans/\(planId)/check-info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getkPlaceVerification:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getkPlaceVerification:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
