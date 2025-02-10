//
//  ScheduleSearch.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation

struct ScheduleSearchRequest: Encodable {
    let keyword: String
    let latitude: String
    let longitude: String
}

struct ScheduleSearchResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PlaceListResult
    
    struct PlaceListResult: Decodable {
        let placeList: [Place]
    }
    
    struct Place: Decodable {
        let placeName: String
    }
}
