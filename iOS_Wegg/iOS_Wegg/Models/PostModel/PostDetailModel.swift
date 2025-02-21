//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/22/25.
//

import Foundation
import UIKit

struct PostDetailModel: Codable {
    let postId: Int
    let nickname: String
    let profileImage: String
    let postImages: String
    let postTime: String // ✅ 변환 없이 그대로 저장
    let comments: [String]

    //  BrowsePost → PostDetailModel 변환 생성자
    init(from browsePost: BrowsePost) {
        self.postId = browsePost.postId  // ✅ postId 저장
        self.nickname = browsePost.accountId
        self.profileImage = browsePost.profileImageUrl ?? "default_image"
        self.postImages = browsePost.postImageUrl
        self.postTime = browsePost.createdAt // 문자열 그대로 저장
        self.comments = ["좋아요!", "멋진 사진이네요!", "Wegg 응원합니다!"] // 예제 댓글
    }
    
    // ✅ 경과 시간 변환을 사용할 때만 Date로 변환
    func timeAgoSincePost() -> String {
        guard let postDate = Self.convertDate(from: postTime) else { return "알 수 없음" }
        
        let now = Date()
        let diff = Int(now.timeIntervalSince(postDate)) // 초 단위 차이 계산
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        switch diff {
        case 0..<minute:
            return "방금 전"
        case minute..<hour:
            return "\(diff / minute)분 전"
        case hour..<day:
            return "\(diff / hour)시간 전"
        case day..<(7 * day):
            return "\(diff / day)일 전"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: postDate) // 7일 이상이면 날짜 그대로 표시
        }
    }
    
    private static func convertDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ✅ "2025-02-19T21:08:43" 형식과 일치
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 기준

        if let date = formatter.date(from: dateString) {
            print("✅ 변환 성공: \(date)")
            return date
        } else {
            print("❌ 변환 실패 - 잘못된 날짜 형식: \(dateString)")
            return nil
        }
    }
}
