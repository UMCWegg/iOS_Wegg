//
//  BottomSheetModel.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/29/25.
//

import Foundation

struct HotPlaceSectionModel {
    let addressId: Int
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
    let savedStatus: Bool?
    let authPeople: Int?
    let phoneNumber: String
}
