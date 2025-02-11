//
//  File.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//

/// 게시물 업로드 요청 모델
import Foundation
import UIKit

/// 게시물 업로드 요청 모델
struct UploadRequest {
    let imageData: Data
    let planId: String

    init(image: UIImage, planId: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            fatalError("❌ 이미지 변환 실패: JPEG 데이터로 변환할 수 없습니다.")
        }
        self.imageData = data
        self.planId = planId
    }
}
