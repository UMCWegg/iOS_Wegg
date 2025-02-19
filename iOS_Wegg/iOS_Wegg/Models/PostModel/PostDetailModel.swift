//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/22/25.
//

import Foundation
import UIKit

/// 게시물 상세 정보 모델
struct PostDetailModel: Codable {
    let nickname: String
    let profileImage: String
    let postImages: String
    let postTime: Date
    let comments: [String]
    
    // ✅ BrowsePost → PostDetailModel 변환 생성자 추가
    init(from browsePost: BrowsePost) {
        self.nickname = browsePost.accountId
        self.profileImage = browsePost.profileImageUrl ?? "default_image"
        self.postImages = browsePost.postImageUrl
        self.postTime = Self.convertDate(from: browsePost.createdAt) // ✅ 날짜 변환
        self.comments = ["좋아요!", "멋진 사진이네요!", "Wegg 응원합니다!"] // 예제 댓글
    }
    
    // ✅ createdAt(String)을 Date로 변환하는 메서드
    private static func convertDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 서버에서 사용하는 형식에 맞춤
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
        return formatter.date(from: dateString) ?? Date() // 변환 실패 시 현재 시간 사용
    }
}
