//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//
import Moya
import Foundation

enum PostAPI {
    case uploadRandomPost(imageData: Data)
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
        case .uploadRandomPost(let imageData):
            let multipartData = MultipartFormData(
                provider: .data(imageData),
                name: "postImage", // Swagger 문서의 필드명과 일치해야 함
                fileName: "image.png", // PNG로 고정
                mimeType: "image/png" // PNG MIME 타입 고정
            )
            return .uploadMultipart([multipartData])
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
    }
}
