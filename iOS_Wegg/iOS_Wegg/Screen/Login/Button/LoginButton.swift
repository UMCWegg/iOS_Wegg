//
//  NaverLoginButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.17.
//

import UIKit

class LoginButton: UIButton {
    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupButton(title: title, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        layer.cornerRadius = 32
        titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        setTitleColor(backgroundColor == .black ? .white : .black, for: .normal)
        
        heightAnchor.constraint(equalToConstant: 61).isActive = true
    }
}

extension UIColor {
    // HEX 문자열을 UIColor로 변환하는 초기화 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        let red, green, blue, alpha: CGFloat
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
            alpha = 1.0
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
