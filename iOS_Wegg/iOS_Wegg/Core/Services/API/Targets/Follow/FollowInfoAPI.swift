//
//  FollowAPI.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import Foundation

import Moya

enum FollowAPI {
    case follow(followeeId: Int)
    case unfollow(followeeId: Int)
}

extension FollowAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        return "/follow"
    }
    
    var method: Moya.Method {
        switch self {
        case .follow:
            return .patch
        case .unfollow:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .follow(let followeeId), .unfollow(let followeeId):
            return .requestJSONEncodable(Followee(followeeID: followeeId))
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
