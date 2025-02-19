//
//  UIView+extensions.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/14/25.
//

import UIKit

extension UIView {
    /// UIView를 UIImage로 변환하는 함수
    /// - Parameters:
    ///   - backgroundColor: 배경색 (기본값: 투명 `.clear`)
    func toImage(backgroundColor: UIColor = .clear) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale // 고해상도 디바이스 지원

        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: format)
        return renderer.image { context in
            // 배경색 설정 (기본값은 투명)
            backgroundColor.setFill()
            context.fill(bounds)

            // 현재 뷰를 렌더링
            layer.render(in: context.cgContext)
        }
    }
}
