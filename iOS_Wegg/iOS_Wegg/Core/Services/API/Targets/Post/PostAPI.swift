//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//
import Moya
import Foundation

enum PostAPI {
    case uploadRandomPost(request: UploadRequest)
}

extension PostAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .uploadRandomPost:
            return APIConstants.Post.uploadRandomPost
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
            switch self {
            case .uploadRandomPost(let request):
                return .uploadMultipart(request.toMultipartFormData()) // MultipartFormData로 추가
            }
        }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
    }
}
