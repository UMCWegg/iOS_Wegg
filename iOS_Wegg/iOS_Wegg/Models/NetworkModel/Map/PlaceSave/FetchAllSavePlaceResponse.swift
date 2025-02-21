//
//  FetchAllBookMarkPlaceResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/21/25.
//

import Foundation

struct FetchAllBookMarkPlaceResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BookMarkResult
    
    struct BookMarkResult: Decodable {
        let bookmarkPlaceList: [BookMarkPlaceList]
    }
    
    struct BookMarkPlaceList: Decodable {
        let addressId: Int
        let latitude: Double
        let longitude: Double
        let placeName: String
        let placeLabel: String
        let authCount: Int
        let saveCount: Int
        let postList: [PostList]
    }
    
    struct PostList: Decodable {
        let postId: Int
        let imageUrl: String
    }
}
