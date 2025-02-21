//
//  EmojiResponse.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 이모지 조회 응답 모델
struct EmojiResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmojiResult
}

/// 이모지 데이터 구조
struct EmojiResult: Decodable {
    let postId: Int
    let userSelectedEmojis: [String] // 사용자가 선택한 이모지 리스트
    let emojiCounts: [EmojiCount] // 각 이모지별 개수
}

/// 개별 이모지 데이터
struct EmojiCount: Decodable {
    let emojiType: String
    let count: Int
}
