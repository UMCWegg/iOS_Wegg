//
//  FetchAllSchedulesResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct FetchAllSchedulesResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [AllSchedulesResult]
    
    struct AllSchedulesResult: Decodable {
        let planId: Int
        let status: String
        let startTime: String
        let finishTime: String
        let lateTime: LateStatus
        let latitude: Double
        let longitude: Double
        let address: String
        let content: String?
        let userId: Int
    }
}
