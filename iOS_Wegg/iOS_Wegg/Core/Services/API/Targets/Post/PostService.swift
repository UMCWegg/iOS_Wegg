//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//

import Foundation
import UIKit

class PostService {
    private let apiManager = APIManager()

    /// 📌 게시물 업로드 API 호출
    func uploadPost(image: UIImage, planId: String) async throws -> UploadResponse {
        let request = UploadRequest(image: image, planId: planId) // 📌 planId 추가
        return try await apiManager.request(target: PostAPI.uploadRandomPost(request: request))
    }
}
