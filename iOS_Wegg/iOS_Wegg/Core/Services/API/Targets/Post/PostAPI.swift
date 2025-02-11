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
            var multipartData: [MultipartFormData] = []
            
            // 📌 1. 이미지 데이터 추가 (postImage)
            let imageData = MultipartFormData(
                provider: .data(request.imageData),
                name: "postImage",
                fileName: "image.jpg",
                mimeType: "image/jpeg"
            )
            multipartData.append(imageData)
            
            // 📌 2. JSON 데이터 추가 (requestDTO)
            let jsonData = try? JSONSerialization.data(
                withJSONObject: ["planId": request.planId],
                options: [])
            if let jsonData = jsonData {
                let requestDTO = MultipartFormData(
                    provider: .data(jsonData),
                    name: "requestDTO",
                    mimeType: "application/json"
                )
                multipartData.append(requestDTO)
            }
            
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
    }
}
