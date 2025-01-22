//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/22/25.
//

import Foundation

/// 게시물 상세 정보 모델
struct PostDetail {
    let nickname: String
    let profileImage: String
    let postTime: Date
    let postImage: String
    let emoge: String
    let comments: [String]
}
