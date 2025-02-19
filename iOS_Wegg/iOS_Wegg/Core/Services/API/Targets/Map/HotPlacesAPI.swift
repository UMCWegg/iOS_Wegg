//
//  HotPlacesAPI.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation
import Moya

enum HotPlacesAPI {
    case getHotPlaces(request: HotPlaceRequest)
    case searchHotPlaces(request: SearchHotplaceRequest)
    case getPlaceDetailInfo(request: HotplaceDetailInfoRequest)
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
        case .searchHotPlaces:
            return "/maps/hotplaces/search"
        case .getPlaceDetailInfo:
            return APIConstants.Map.detailInfoURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHotPlaces, .searchHotPlaces, .getPlaceDetailInfo:
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
        case .searchHotPlaces(let request):
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
        case .getPlaceDetailInfo(let request):
            return .requestParameters(
                parameters: [
                    "placeName": request.placeName
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
