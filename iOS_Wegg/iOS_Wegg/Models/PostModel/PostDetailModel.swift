//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/22/25.
//

import Foundation

/// 게시물 상세 정보 모델
struct PostDetailModel: Codable {
    let nickName: String
    let profileImage: String
    let postImages: [String]
    let postTime: Date
    let comments: [String]
    
    /// Mock데이터를 반환하는 정적 메서드
    static func mockData(for browseItem: BrowseItem) -> PostDetailModel {
        return PostDetailModel(
            nickName: browseItem.nickName,
            profileImage: browseItem.profileImage,
            postImages: browseItem.postImage,
            postTime: Date(),
            comments: ["좋아여", "Wegg화이팅^^", "종증윤"]
        )
    }
}
