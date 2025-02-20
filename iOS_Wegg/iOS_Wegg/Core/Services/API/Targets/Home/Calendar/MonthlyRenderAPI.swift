//
//  MonthlyRenderAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/20/25.
//

import Foundation
import Moya

enum MonthlyRenderAPI {
    case getMonthlyRender
}

extension MonthlyRenderAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMonthlyRender:
            return APIConstants.MonthlyRenderURL.monthlyRenderURL
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
