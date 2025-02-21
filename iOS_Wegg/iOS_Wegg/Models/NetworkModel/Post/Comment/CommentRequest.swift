//
//  CommentRequest.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 댓글 등록 요청 모델
struct CommentRequest: Encodable {
    let postingId: Int
    let comment: String
    let parentId: Int? // 부모 댓글 ID (대댓글이 아닌 경우 null)
}
