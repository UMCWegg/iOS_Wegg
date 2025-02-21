//
//  HotPlaceRequest.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import Foundation

struct HotPlaceRequest: Encodable {
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    let sortBy: String
    let page: Int
    let size: Int
}
