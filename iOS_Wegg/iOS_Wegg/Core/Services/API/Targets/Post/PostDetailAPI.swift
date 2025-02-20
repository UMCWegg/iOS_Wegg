//
//  PostDetailAPI.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Moya
import Foundation

enum PostDetailAPI {
    case getComments(postId: Int, page: Int, size: Int) // 댓글 조회
    case getEmojis(postId: Int) // 이모지 조회
    case postEmoji(postId: Int) // 이모지 등록
    case postComment(request: CommentRequest) // 댓글 등록
}

extension PostDetailAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://weggserver.store") else {
            fatalError("❌ 잘못된 Base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getComments(let postId, _, _):
            return "/posts/\(postId)/comments"
        case .getEmojis(let postId):
            return "/posts/\(postId)/emoji"
        case .postEmoji(let postId):
            return "/posts/\(postId)/emoji"
        case .postComment:
            return "/posts/comment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments, .getEmojis:
            return .get
        case .postEmoji, .postComment:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getComments(_, let page, let size):
            return .requestParameters(
                parameters: ["page": page, "size": size],
                encoding: URLEncoding.queryString)
            
        case .getEmojis:
            return .requestPlain // Body 없이 요청
            
        case .postEmoji:
            return .requestPlain // Body 없이 요청
        
        case .postComment(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
