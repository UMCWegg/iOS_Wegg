//
//  SettingViewButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

import Then
import SnapKit

class SettingViewButton: UIButton {

    // MARK: - Init
    
    init(title: String) {
        super.init(frame: .zero)
        self.heightAnchor.constraint(equalToConstant: 61).isActive = true
        setupButton()
        mainTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private let mainTitle = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.textColor = .black
    }
    
    private func setupButton() {
        backgroundColor = .clear
        addSubview(mainTitle)
        
        mainTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
        }
    }
}
