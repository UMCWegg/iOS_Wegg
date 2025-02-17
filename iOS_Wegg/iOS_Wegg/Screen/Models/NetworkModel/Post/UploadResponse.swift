//
//  UploadResponse.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//

import Foundation

/*  result가 String일 경우, 디코딩 실패 후 result = nil로 설정하여 오류 방지
 서버에서 예기치 않게 문자열을 보낼 경우, 기본 응답(UploadResponse)을 반환하여 앱이 크래시되지 않음 */

/// 게시물 업로드 응답 모델
struct UploadResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostResult?  // result를 Optional로 변경
}

/// 서버가 반환하는 게시물 정보
struct PostResult: Decodable {
    let postId: Int
    let templateId: Int? // 서버에서는 null값이므로 옵셔널로 변경
    let planId: Int
    let createdAt: String
}
