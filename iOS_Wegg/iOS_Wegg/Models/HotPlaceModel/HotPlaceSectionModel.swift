//
//  BottomSheetModel.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import Foundation

struct HotPlaceSectionModel {
    var header: HotPlaceHeaderModel
    let items: [HotPlaceImageModel]
    var details: HotPlaceDetailModel?
}

struct HotPlaceHeaderModel {
    let title: String
    let category: String
    let address: String?
    let verificationCount: String
    let saveCount: String
}

struct HotPlaceImageModel {
    let imageName: String
}

struct HotPlaceDetailModel {
    let phoneNumber: String
}

extension HotPlaceSectionModel {
    static var sampleSections: [HotPlaceSectionModel] = [
        .init(
            header: .init(
                title: "스타벅스 신용산점",
                category: "카페",
                address: "서울특별시 성북구",
                verificationCount: "인증 99+",
                saveCount: "저장 34"
            ),
            items: HotPlaceImageModel.sampleData,
            details: nil
        ),
        .init(
            header: .init(
                title: "스타벅스 신용산점",
                category: "카페",
                address: "서울특별시 성북구",
                verificationCount: "인증 99+",
                saveCount: "저장 34"
            ),
            items: HotPlaceImageModel.sampleData,
            details: nil
        ),
        .init(
            header: .init(
                title: "스타벅스 신용산점",
                category: "카페",
                address: "서울특별시 성북구",
                verificationCount: "인증 99+",
                saveCount: "저장 34"
            ),
            items: HotPlaceImageModel.sampleData,
            details: nil
        ),
        .init(
            header: .init(
                title: "스타벅스 신용산점",
                category: "카페",
                address: "서울특별시 성북구",
                verificationCount: "인증 99+",
                saveCount: "저장 34"
            ),
            items: HotPlaceImageModel.sampleData,
            details: nil
        )
    ]
}

extension HotPlaceImageModel {
    static let sampleData: [HotPlaceImageModel] = [
        .init(imageName: "study_1"),
        .init(imageName: "study_2"),
        .init(imageName: "study_3"),
        .init(imageName: "study_4")
    ]
}
