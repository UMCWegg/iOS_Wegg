//
//  UserSearchResponse.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

/// 사용자 검색 응답 모델
struct UserSearchResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [UserSearchResult] // ✅ 검색 결과 배열
}

/// 개별 사용자 정보
struct UserSearchResult: Decodable {
    let userId: Int
    let accountId: String
    let profileImage: String? // ✅ 프로필 이미지가 없을 수도 있음 (nullable)
}
