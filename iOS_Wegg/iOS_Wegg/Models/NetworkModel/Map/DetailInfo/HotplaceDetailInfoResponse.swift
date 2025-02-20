//
//  HotplaceDetailInfoResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/20/25.
//

import Foundation

struct HotplaceDetailInfoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DetailList
    
    struct DetailList: Decodable {
        let detailList: [Detail]
    }
    
    struct Detail: Decodable {
        let addressId: Int
        let placeName: String
        let authPeople: Int
        let authCount: Int
        let saveCount: Int
        let placeLabel: String
        let roadAddress: String
        let phone: String
        let postList: [PostList]
    }
    
    struct PostList: Decodable {
        let postId: Int
        let imageUrl: String
    }
}
