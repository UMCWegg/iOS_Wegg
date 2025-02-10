//
//  HotPlacesResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation

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
