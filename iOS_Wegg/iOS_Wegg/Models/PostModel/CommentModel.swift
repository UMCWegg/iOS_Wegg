//
//  CommentModel.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import Foundation
import UIKit

/// 댓글 데이터를 관리하는 모델
struct CommentModel {
    let userName: String // 댓글 작성자 닉네임
    let profileImage: UIImage?
    let commentText: String // 댓글 내용
    
    // 댓글 테이블뷰는 배열로 관리되기 때문에 CommentModel 타입을 요소로 가지는 배열을 반환
    static func getMockdata() -> [CommentModel] {
        return [
            CommentModel(
                userName: "증윤",
                profileImage: UIImage(named: "profile1"),
                commentText: "Wegg입니다."),
            CommentModel(
                userName: "리버",
                profileImage: UIImage(named: "profile1"),
                commentText: "Wegg입니다."),
            CommentModel(
                userName: "하키",
                profileImage: UIImage(named: "profile1"),
                commentText: "Wegg입니다."),
            CommentModel(
                userName: "베텔",
                profileImage: UIImage(named: "profile1"),
                commentText: "Wegg입니다.")
        ]
    }
}
