//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/22/25.
//

import Foundation

/// 게시물 상세 정보 모델
struct PostDetail {
    let nickName: String
    let profileImage: String
    let postImages: [String]
    let postTime: Date
    let comments: [String]
}
