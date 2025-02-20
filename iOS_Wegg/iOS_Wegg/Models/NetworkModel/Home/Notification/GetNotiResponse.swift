//
//  GetNotiResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/21/25.
//

import Foundation

struct GetNotiResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: GetNotiResult
}

struct GetNotiResult: Codable {
    let accountVisibility: String
    let latestFollowerAccountId: String
    let waitingFollowRequests: Int
    let notifications: [GetNoti]
}

struct GetNoti: Codable {
    let notificationId: Int
    let notificationType: String
    let content: String
    let url: String
    let readStatus: String
    let imageUrl: String
}
