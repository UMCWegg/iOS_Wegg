//
//  BrowseAPI.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/12/25.
//

import Foundation
import Moya

/// 둘러보기 탭 API 정의
enum BrowseAPI {
    case fetchBrowsePosts(request: BrowseRequest)
}

extension BrowseAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchBrowsePosts:
            return APIConstants.Browse.fetchBrowsePosts
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
            switch self {
            case .fetchBrowsePosts(let request):
                return .requestParameters(
                    parameters: request.toParameters(), // ✅ Query Parameters 구조화
                    encoding: URLEncoding.default
                )
            }
        }
    
    var headers: [String: String]? {
            return ["Content-Type": "application/json"]
        }
}
