//
//  WeelyRenderAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/18/25.
//

import Foundation
import Moya

enum WeeklyResponseAPI {
    case getWeeklyRender
}

extension WeeklyResponseAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getWeeklyRender:
            return APIConstants.WeeklyRenderURL.weeklyRenderURL
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
