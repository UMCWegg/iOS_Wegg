//
//  BrowseItem.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import Foundation

/// 둘러보기 탭 모델
struct BrowseItem: Codable {
    /// 사용자 닉네임
    let nickName: String
    
    /// 사용자 프로필 이미지 URL 또는 이름
    let profileImage: String
    
    /// 게시물 이미지 리스트 (URL 또는 이름)
    let postImage: [String]
}
