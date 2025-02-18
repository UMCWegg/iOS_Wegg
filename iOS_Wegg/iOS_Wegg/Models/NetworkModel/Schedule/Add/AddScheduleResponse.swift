//
//  AddScheduleResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct AddScheduleResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [SchedulePlan]
    
    struct SchedulePlan: Decodable {
        let planId: Int
        let createdAt: String
        var warningMessage: String?
    }
}
