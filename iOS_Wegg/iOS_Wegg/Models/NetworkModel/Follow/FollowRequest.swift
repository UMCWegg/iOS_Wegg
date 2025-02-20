//
//  FollowRequest.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

struct Followee: Codable {
    let followeeID: Int
    
    enum CodingKeys: String, CodingKey {
        case followeeID = "followeeId"
    }
}

struct Follower: Codable {
    let followerID: Int
    
    enum CodingKeys: String, CodingKey {
        case followerID = "followerId"
    }
}
