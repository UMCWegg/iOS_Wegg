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
        
        setTitleColor((backgroundColor == .black ||
                       backgroundColor == UIColor(named: "BluePrimary"))
                       ? .white : .black, for: .normal)
        
        heightAnchor.constraint(equalToConstant: 61).isActive = true
    }
}
