//
//  UIImageView+extensions.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/13/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// Kingfisher 기반 이미지 로드 메서드
    /// - Parameters:
    ///   - urlString: 이미지 URL 주소
    ///   - placeholder: 이미지 로딩 동안 표시할 플레이스홀더
    ///   - cacheMemoryOnly: 메모리 캐시만 사용할지 여부 (기본값: false, 디스크 캐시까지 사용)
    ///   - completion: 이미지 로드 완료 후 실행할 클로저 (옵션)
    func setImage(
        from urlString: String?,
        placeholder: String = "placeholder",
        cacheMemoryOnly: Bool = false,
        completion: (@Sendable (
            Result<RetrieveImageResult, KingfisherError>
        ) -> Void)? = nil
    ) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = UIImage(named: placeholder)
            return
        }
        
        let cacheOption: [KingfisherOptionsInfoItem] = cacheMemoryOnly ? [.cacheMemoryOnly] : []
        
        let modifier = AnyModifier { request in
            var req = request
            req.timeoutInterval = 10 // 10초 타임아웃 설정
            return req
        }
        
        self.kf.setImage(
            with: url,
            placeholder: self.image ?? UIImage(named: placeholder), // 기존 이미지 유지
            options: [
                .requestModifier(modifier),  // 네트워크 타임아웃 설정
                .transition(.fade(0.3))
            ] + cacheOption,
            completionHandler: completion
        )
    }
    
    /// 네트워크 이미지를 로드하고, 실패 시 로컬 placeholder 이미지를 표시
    func loadImage(from urlString: String?, placeholder: String) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = UIImage(named: placeholder) // ✅ 지정된 placeholder 사용
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(named: placeholder) // ✅ 네트워크 실패 시 지정된 placeholder 사용
                }
            }
        }
    }
}
