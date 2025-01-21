//
//  UIColor+extensions.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/20/25.
//

import Foundation
import UIKit

extension UIColor {
    /// 앱의 주요 색상 그룹 정의
    enum CustomColor {
        case primary
        case secondary
        //        case background
        //        case accent
        
        /// 색상 반환
        func color() -> UIColor {
            switch self {
            case .primary:
                guard let color = UIColor(named: "BluePrimary") else {
                    return UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0) // 기본 파랑
                }
                return color
            case .secondary:
                guard let color = UIColor(named: "YellowSecondary") else {
                    return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // 기본 노랑
                }
                return color
            }
        }
    }
    
    /// Static 메서드로 사용 가능
    /// - UIFont.customColor(.primary)
    static func customColor(_ color: CustomColor) -> UIColor {
        return color.color()
    }
}
