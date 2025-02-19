//
//  DeleteScheduleResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct DeleteScheduleResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DeleteScheduleResult
    
    struct DeleteScheduleResult: Decodable {
        let planId: Int
        let planDate: String
        let startTime: String
        let address: String
    }
}
