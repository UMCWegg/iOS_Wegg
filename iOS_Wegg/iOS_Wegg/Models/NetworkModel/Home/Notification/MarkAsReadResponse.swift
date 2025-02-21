//
//  MarkAsReadResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/21/25.
//

import Foundation

struct MarkAsReadResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MarkAsReadResult
}

struct MarkAsReadResult: Codable {
    let notificationId: Int
    let readStatus: String
}
