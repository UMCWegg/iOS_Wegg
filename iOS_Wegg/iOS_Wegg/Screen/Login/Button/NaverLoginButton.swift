//
//  NaverLoginButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.17.
//

import UIKit

class NaverLoginButton: UIButton {
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "Login/Naver/btnG_아이콘사각")
        $0.contentMode = .scaleAspectFit
    }
    
    private let naverTitleLabel = UILabel().then {
        $0.text = "네이버 로그인"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(hex: "03C75A")
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func setupLayout() {
        [iconImageView, naverTitleLabel].forEach { addSubview($0) }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        naverTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-88)
        }
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

