//
//  BottomSheetModel.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import Foundation

struct HotPlaceModel {
    let imageName: String
}

extension HotPlaceModel {
    static let sampleData: [HotPlaceModel] = [
        .init(imageName: "study_1"),
        .init(imageName: "study_2"),
        .init(imageName: "study_3"),
        .init(imageName: "study_4")
    ]
}
