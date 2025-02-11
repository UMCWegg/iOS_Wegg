//
//  UploadResponse.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//

import Foundation

/// 게시물 업로드 응답 모델
struct UploadResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostResult
}

/// 서버가 반환하는 게시물 정보
struct PostResult: Decodable {
    let postId: Int
    let templateId: Int
    let planId: Int
    let createdAt: String
}
