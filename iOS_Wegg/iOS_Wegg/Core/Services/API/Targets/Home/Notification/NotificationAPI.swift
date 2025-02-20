//
//  NotificationAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/21/25.
//

import Foundation
import Moya

enum NotificationAPI {
    case notification // 알림 목록 가져오기
    case markAsRead(notificationId: Int, readStatus: String) // 알림 읽음 표시하기
}

extension NotificationAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }

    var path: String {
        switch self {
        case .notification:
            return APIConstants.NotificationURL.notificationURL
        case .markAsRead(let notificationId, _):
            return APIConstants.NotificationURL.markAsReadURL(notificationId: notificationId)
        }
    }

    var method: Moya.Method {
        switch self {
        case .notification:
            return .get
        case .markAsRead:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .notification:
            return .requestPlain
        case .markAsRead(_, let readStatus):
            let request = MarkAsReadRequest(readStatus: readStatus)
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
