//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/12/25.
//

import Foundation

/// 둘러보기탭에서 사용자의 게시물과 정보를 받아오는 구조체
struct BrowseResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [[BrowsePost]] // 2차원배열 (팔로우O / 팔로우x)
}

struct BrowsePost: Decodable {
    let postID: Int
    let profileImageUrl: String
    let nickname: String
    let postImageUrl: String
    let createdAt: String
}
