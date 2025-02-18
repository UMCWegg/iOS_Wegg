//
//  AddScheduleRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct AddScheduleRequest: Encodable {
    let status: ScheduleStatus
    let planDates: [String]
    let startTime: String
    let finishTime: String
    let lateTime: String
    let placeName: String
    let planOn: Bool
}
