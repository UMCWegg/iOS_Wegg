//
//  SearchHotplaceResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct SearchHotplaceResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SearchResult
    
    struct SearchResult: Decodable {
        let placeList: [PlaceList]
    }
    
    struct PlaceList: Decodable {
        let addressId: Int
        let placeName: String
        let roadAddress: String
        let distance: Double
        let authCount: Int
    }
}
