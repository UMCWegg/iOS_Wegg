//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//
import Foundation
import UIKit
import Moya
/*
 게시물 API 요청중 아이폰으로 찍은 사진크기가 비대함 -> 압축
 이미지파일 압축 메서드 UIImage+Extension파일에 선언후 사용
 */

/// 게시물 업로드 요청 모델
struct UploadRequest {
    let imageData: Data
    let planId: Int

    init(image: UIImage, planId: Int) {
        // 1. 이미지 리사이징 (가로 800px)
        let resizedImage = image.resized(toWidth: 800) ?? image
        
        // 2. JPEG 변환 (압축률 0.7)
        guard let data = resizedImage.compressedData(quality: 0.7) else {
            fatalError("❌ 이미지 변환 실패: JPEG 데이터로 변환할 수 없습니다.")
        }
        
        self.imageData = data
        self.planId = planId
    }

    /// `MultipartFormData` 변환 (PostAPI에서 직접 호출)
    func toMultipartFormData() -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        
        // 1. 이미지 데이터 추가
        let imageData = MultipartFormData(
            provider: .data(self.imageData),
            name: "postImage",
            fileName: "image.jpg",
            mimeType: "image/jpeg"
        )
        multipartData.append(imageData)
        
        // 2. JSON 데이터 추가
        if let jsonData = try? JSONSerialization.data(
            withJSONObject: ["planId": self.planId], options: []) {
            let requestDTO = MultipartFormData(
                provider: .data(jsonData),
                name: "requestDTO",
                mimeType: "application/json"
            )
            multipartData.append(requestDTO)
        }
        
        return multipartData
    }
}
