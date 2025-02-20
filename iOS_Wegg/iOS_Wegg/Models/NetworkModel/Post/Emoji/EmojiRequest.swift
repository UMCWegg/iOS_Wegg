//
//  EmojiRequest.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 이모지 등록을 위한 요청 모델
struct EmojiRequest: Encodable {
    let type: String // 서버에서 기대하는 "type" 값
}
