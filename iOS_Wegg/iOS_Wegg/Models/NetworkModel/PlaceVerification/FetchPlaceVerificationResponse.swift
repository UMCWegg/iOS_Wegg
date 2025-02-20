//
//  FetchPlaceVerificationResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/20/25.
//

import Foundation

struct FetchPlaceVerificationResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultResponse
    
    struct ResultResponse: Decodable {
        let planId: Int
        let placeName: String
        let latitude: Double
        let longitude: Double
        let startTime: String
    }
}
