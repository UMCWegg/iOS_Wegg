//
//  PlaceVerificationAPI.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/20/25.
//

import Foundation
import Moya

enum PlaceVerificationAPI {
    case checkPlaceVerification(planId: Int)
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
        case .checkPlaceVerification(let planId):
            return "/plans/\(planId)/check-info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkPlaceVerification:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .checkPlaceVerification:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
