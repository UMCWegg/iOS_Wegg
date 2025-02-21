//
//  CommentResponse.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 댓글 조회 응답 모델
struct CommentResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Comment]
}

/// 개별 댓글 데이터
struct Comment: Decodable {
    let commentId: Int
    let parentId: Int?
    let userId: Int
    let accountId: String
    let content: String
    let commenterProfileUrl: String
    let createdAt: String
}
