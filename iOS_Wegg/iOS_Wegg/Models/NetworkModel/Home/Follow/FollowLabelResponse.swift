//
//  FollowLabelResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/18/25.
//

import Foundation

struct FollowLabelResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FollowLabelResult
}

struct FollowLabelResult: Decodable {
    let followerCount: Int
    let followingCount: Int
    let profileImage: String?
    let accountId: String
}
