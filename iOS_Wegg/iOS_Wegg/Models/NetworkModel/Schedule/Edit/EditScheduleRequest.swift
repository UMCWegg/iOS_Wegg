//
//  EditScheduleRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/21/25.
//

import Foundation

struct EditScheduleRequest: Encodable {
    let startTime: String
    let finishTime: String
    let lateTime: LateStatus
}
