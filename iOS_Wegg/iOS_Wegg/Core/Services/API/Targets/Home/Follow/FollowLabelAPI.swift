//
//  FollowLabelAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/18/25.
//

import Foundation
import Moya

enum FollowAPI {
    case getFollowInfo
}

extension FollowAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        return APIConstants.FollowLabel.followLabelURL
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

