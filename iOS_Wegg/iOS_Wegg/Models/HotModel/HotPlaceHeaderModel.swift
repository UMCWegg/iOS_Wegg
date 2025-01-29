//
//  HotPlaceHeaderModel.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import Foundation

struct HotPlaceHeaderModel {
    let title: String
    let category: String
    let verificationCount: String
    let saveCount: String
}

extension HotPlaceHeaderModel {
    static let sampleDate: [HotPlaceHeaderModel] = [
        .init(
            title: "스타벅스 신용산점",
            category: "카페",
            verificationCount: "99+",
            saveCount: "34"
        ),
        .init(
            title: "스타벅스 신용산점",
            category: "카페",
            verificationCount: "99+",
            saveCount: "34"
        ),
        .init(
            title: "스타벅스 신용산점",
            category: "카페",
            verificationCount: "99+",
            saveCount: "34"
        )
    ]
}
