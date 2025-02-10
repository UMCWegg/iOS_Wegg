//
//  HotPlacesAPI.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation
import Moya

struct HotPlaceRequest: Encodable {
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    let sortBy: String
}

struct HotPlacesResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: HotPlacesResult
    
    struct HotPlacesResult: Codable {
        let hotPlaceList: [HotPlace]
    }
    
    struct HotPlace: Codable {
        let addressId: Int
        let latitude: Double
        let longitude: Double
        let placeName: String
        let placeLabel: String
        let authCount: Int
        let saveCount: Int
        let distance: Double
        let postList: [String] // 현재 postList는 비어 있으므로 String 배열로 처리
    }
}

enum HotPlacesAPI {
    case getHotPlaces(request: HotPlaceRequest)
}

extension HotPlacesAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ [ScheduleTargetType] 유효하지 않은 URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getHotPlaces:
            return APIConstants.Map.hotplacesURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHotPlaces:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getHotPlaces(let request):
            return .requestParameters(
                parameters: [
                    "minX": request.minX,
                    "maxX": request.maxX,
                    "minY": request.minY,
                    "maxY": request.maxY,
                    "sortBy": request.sortBy
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

extension APIManager {
    func fetchHotPlaces(
        request: HotPlaceRequest,
        completion: @escaping (Result<HotPlacesResponse, APIError>) -> Void
    ) {
        self.request(
            target: HotPlacesAPI.getHotPlaces(request: request),
            completion: completion
        )
    }
}
