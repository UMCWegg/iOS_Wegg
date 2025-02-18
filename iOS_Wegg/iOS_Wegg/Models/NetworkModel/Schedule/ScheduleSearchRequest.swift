//
//  ScheduleSearchRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation

struct ScheduleSearchRequest: Encodable {
    let keyword: String
    let latitude: String
    let longitude: String
    let page: Int
    let size: Int
}
