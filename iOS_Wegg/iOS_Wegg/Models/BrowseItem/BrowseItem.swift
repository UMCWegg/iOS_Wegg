//
//  BrowseItem.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import Foundation

/// 둘러보기 탭 모델
struct BrowseItem: Codable {
    /// 사용자 닉네임
    let nickName: String
    
    /// 사용자 프로필 이미지 URL 또는 이름
    let profileImage: String
    
    /// 게시물 이미지 리스트 (URL 또는 이름)
    let postImage: [String]
    
    /// Mock 데이터를 반환하는 정적 메서드
    /// - browseItems = BrowseItem.mockData()
    static func mockData() -> [BrowseItem] {
        return [
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile_placeholder",
                postImage: ["post1-1", "post1-2"]),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile_placeholder",
                postImage: ["post2-1", "post2-2"]),
            BrowseItem(
                nickName: "하키",
                profileImage: "profile_placeholder",
                postImage: ["post1-1", "post3-2"]),
            BrowseItem(
                nickName: "베텔",
                profileImage: "profile_placeholder",
                postImage: ["post2-1", "post1-2"]),
            BrowseItem(
                nickName: "소피",
                profileImage: "profile_placeholder",
                postImage: ["post1-1", "post2-2"]),
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"]),
            BrowseItem(
                nickName: "증윤",
                profileImage: "profile1",
                postImage: ["post1-1", "post1-2"]),
            BrowseItem(
                nickName: "리버",
                profileImage: "profile1",
                postImage: ["post1-1", "post2-2"])
        ]
    }
}
