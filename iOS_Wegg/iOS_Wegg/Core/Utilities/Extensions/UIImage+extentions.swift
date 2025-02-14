//
//  UIImage+extentions.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/11/25.
//

import UIKit
extension UIImage {
    /// 서버에서 png파일은 용량이 많이 부담되기에 jpeg로 압축 거친후 API 통신하기 위함
    /// 이미지 크기를 줄이는 함수 (가로 너비 기준)
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: width, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    /// JPEG 형식으로 변환하여 파일 크기를 줄이는 함수
    func compressedData(quality: CGFloat = 0.7) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    /* 사용예시 :
     let resizedImage = image.resized(toWidth: 800) ?? image
            // 2. JPEG 변환 (압축률 0.7)
            guard let data = resizedImage.compressedData(quality: 0.7) else {
                fatalError("❌이미지 변환 실패: JPEG 데이터로 변환할 수 없습니다.")
            }
     */
}
