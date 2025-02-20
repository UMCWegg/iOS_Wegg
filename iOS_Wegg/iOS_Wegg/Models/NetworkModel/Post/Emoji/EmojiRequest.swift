//
//  EmojiRequest.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 이모지 등록을 위한 요청 모델
struct EmojiRequest: Encodable {
    let postId: Int // 이모지를 등록할 게시물 ID
}
