//
//  LoginLabel.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit

class LoginLabel: UILabel {
    
    // MARK: - Init
    
    init(title: String, type: LabelType) {
        super.init(frame: .zero)
        self.text = title
        setup(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Types
    
    enum LabelType {
        case main
        case sub
    }
    
    // MARK: - Setup
    
    private func setup(type: LabelType) {
        
        textAlignment = .left
        numberOfLines = 0
        
        switch type {
        case .main:
            font = UIFont.LoginFont.title
            textColor = .black
        case .sub:
            font = UIFont.LoginFont.subTitle
            textColor = UIColor.LoginColor.subTitleColor
        }
    }
}
