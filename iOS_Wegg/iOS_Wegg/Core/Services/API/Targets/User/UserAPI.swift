//
//  UserAPI.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Moya
import Foundation

enum UserAPI {
    case searchUser(keyword: String) // ✅ 사용자 검색
}

extension UserAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://weggserver.store") else {
            fatalError("❌ 잘못된 Base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .searchUser:
            return "/users/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchUser(let keyword):
            return .requestParameters(
                parameters: ["keyword": keyword],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
